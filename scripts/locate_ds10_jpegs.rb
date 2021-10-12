#!/usr/bin/env ruby

require 'nokogiri'
require 'csv'

require_relative '../lib/ds'

NS = {
  mods: 'http://www.loc.gov/mods/v3',
  mets: 'http://www.loc.gov/METS/',
}

# We're only interest in these
DEPENDENT_ON_DS = %w{
conception
csl
cuny
grolier
gts
indiana
kansas
nelsonatkins
nyu
providence
rutgers
ucb
wellesley
}.sort.freeze

##
# Transform the incoming METS TIFF name to the correct JPEG version and return
# the JPEG name or +NOT_FOUND+.
#
# The typical conversion is from something like
#
#     dummy_0000078.tif
#
# to
#
#     0000078A.jpg
#
# However, there are nonstandard cases that this method addresses.
#
# @param [Array<String>] image_map array of all the JPEGs for a member institution
# @param [String] filename one image filename from METS XML
# @param [String] inst_dir the institution folder basename; e.g., +ucb+, +grolier+
# @return [String] the name of the JPEG from +image_map+ or +NOT_FOUND+
def find_file image_map:, filename:, inst_dir: ''
  # remove the .tif extension; dummy_0123.tif => dummy_0123
  base = File.basename filename, '.tif'
  raise "File name does not have expected .tif extension: #{filename}" if base == filename

  # Wellesley filenames begin with 'DivinaCommedia';
  #     dummy_0123 => DivinaCommedia_0123.jpg
  if inst_dir.downcase == 'wellesley'
    x = "#{base.sub(%r{^dummy}i, 'DivinaCommedia')}.jpg"
    return x if image_map.include? x
  end

  # Some file names don't start with dummy and end in 'A.jpg'
  #     0123 => 0123A.jpg
  s = "#{base}A.jpg"
  return s if image_map.include? s

  # Some files start with dummy_ which should be remove
  #     dummy_0123A.jpg => 0123A.jpg
  s = s.sub %r{^dummy_?}i, ''
  return s if image_map.include? s

  # the Indiana images have correspondences like
  #
  # dummy_InU-Li_Ricketts-79-00001.tif	=> ricketts-79-00001A.jpg
  # dummy_InU-Li_Poole-18-00001.tif	    => poole-18-00001A.jpg
  if s =~ %r{^InU-Li_}i
    x = s.sub(%r{^InU-Li_}, '').split(%r{-}).map { |p|
      # the whole filename is downcased, except for the 'A' before '.jpg'
      p =~ %r{^\d+A\.jpg} ? p : p.downcase
    }.join '-'
    return x if image_map.include? x
  end

  # Some files have '.' divider before the number rather than '_'
  #     somestring_0123A.jpg => somestring.0123A.jpg
  s.sub! %r{_(\d+A\.jpg)}, '.\1'
  return s if image_map.include? s

  # Sometimes the other conversions are correct, but without 'A'
  #     somestring.0123A.jpg => somestring.0123.jpg
  s.sub! %r{A\.jpg}, '.jpg'
  return s if image_map.include? s

  'NOT_FOUND' # no match found
end

##
# @param [String] images_list the path to the index.html in the images directory
#     for a member institution
# @return [Array<String>] all the JPEGs listed in the index file
def read_images images_list
  images_html = File.open(images_list) { |f| Nokogiri::HTML f }
  images_html.xpath('//table[@id="indexlist"]/tr/td[@class="indexcolicon"][1]/a/@href').map { |href|
    href.text
  }.uniq
end

##
# Given a path containing 'digitalassets.lib.berkeley.edu', trim off the bit
# before +digitalassets.lib.berkeley.edu+.
#
# @param [String] path absolute or relative path to a digitalassets folder; e.g.,
#     /path/to/ds/digitalassets.lib.berkeley.edu/ds/csl
# @return [String] the path beginning with `digitalassets.lib.berkeley.edu`; e.g.,
#     digitalassets.lib.berkeley.edu/ds/csl
def rel_path path
  path.sub %r{^/.*/digitalassets.lib.berkeley.edu}, 'digitalassets.lib.berkeley.edu'
end

##
# Return the relative path to the JPEG file from the directory:
#
#     digitalassets.lib.berkeley.edu/ds/
#
# Returned value will be something like:
#
#     digitalassets.lib.berkeley.edu/ds/gts/images/0000078.jpg
#
# @param [String] inst_dir absolute path to the folder for the institution; e.g.,
#         +/Users/emeryr/NoBackup/ds/digitalassets.lib.berkeley.edu/ds/csl+
# @param [String] jpeg_basename basename of the jpeg file; e.g., +0000078.jpg+
#         or +NOT_FOUND+
# @return [String] the relative path to the image file or +NOT_FOUND+ if no
#         JPEG was found; e.g.,
#         +digitalassets.lib.berkeley.edu/ds/gts/images/0000078.jpg+
def get_found_path inst_dir, jpeg_basename
  return jpeg_basename if jpeg_basename == 'NOT_FOUND'

  # get the relative path to the jpeg; e.g.,
  #   digitalassets.lib.berkeley.edu/ds/gts/images/0000078.jpg
  rel_path(File.join inst_dir, 'images', jpeg_basename)
end

##
# Argument is the folder path to the folder containing the institution folders:
#
#     /path/to/digitalassets.lib.berkeley.edu/ds
#
output_file = "ds-jpeg-locations.csv"
ds_dir      = ARGV.shift
HEADERS     = %i{ inst callno mets_path mets_basename dmdsec_id mets_image_filename jpeg }
CSV.open output_file, 'w+', headers: true do |csv|
  csv << HEADERS
  # Cycle through the DEPENDENT_ON_DS list, for each institution folder get
  # `images/index.html`, and compile an array of the JPEGS in the `images`
  # directory. Then cycle through all the METS XML files in each `mets` dir and
  # find the names of the corresponding images from `index.html`.
  DEPENDENT_ON_DS.each do |inst|
    inst_dir    = File.join ds_dir, inst          # something like path/to/digitalassets.lib.berkeley.edu/ds/gts
    unless File.directory? inst_dir               # for small test data sets; allow missing institutional directories
      STDERR.puts %Q{\e[31mWARNING: Missing directory: #{inst_dir}\e[0m}
      next
    end
    images_list = "#{inst_dir}/images/index.html" # path to the image list; like `path/to/digitalassets.lib.berkeley.edu/ds/gts/images/index.html`
    image_map   = read_images images_list         # an array of all the JPEGs listed in index.html
    STDERR.puts "Processing: '#{inst_dir}'"
    # all the mets files; e.g., `digitalassets.lib.berkeley.edu/ds/missouri/mets/*.xml`
    Dir["#{inst_dir}/mets/*.xml"].each do |mets_xml|
      xml             = File.open(mets_xml) { |f| Nokogiri::XML f }
      row                       = {}
      row[:inst]                = inst
      row[:callno]              = DS::DS10.extract_institution_id xml
      row[:mets_path]           = rel_path mets_xml
      row[:mets_basename]       = File.basename mets_xml
      row[:mets_image_filename] = 'NO_PAGES' # default value
      row[:jpeg]                = 'NO_PAGES' # default value

      pages = DS::DS10.find_pages(xml)
      # if there are no pages, accept the values and go to the next METS file
      pages.empty? and (csv << row) and next

      pages.each do |page_node|
        row[:dmdsec_id] = page_node['ID'] # get the node ID; e.g., DM4
        DS::DS10.extract_filenames(page_node).each do |filename|
          row[:mets_image_filename] = filename
          row[:jpeg]                = 'NO_FILE' # default value

          # if filename isn't present, accept values and go to next filename
          filename == 'NO_FILE' and (csv << row) and next

          # finally, we have a filename; search for it
          found_jpeg = find_file image_map: image_map, filename: filename, inst_dir: inst
          row[:jpeg] = get_found_path inst_dir, found_jpeg
          csv << row
        end
      end
    end
  end
end

STDERR.puts "Wrote: #{output_file}"
