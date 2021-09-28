#!/usr/bin/env ruby

######
# Script to convert UPenn Marc XML to DS 2.0 format.
#
# Input should be an MMS ID.
#
# The initial test set will use these IDs:
#
#   9947675343503681
#   9952666523503681
#   9959647633503681
#   9950569233503681
#   9976106713503681
#   9965025663503681

##
#  Questions
#
# LJs 235 does not have an 099 field; where should the shelfmark come from?
# Vernacular script handling?
#

require 'nokogiri'
require 'csv'
require 'yaml'
require 'optionparser'
require_relative '../lib/ds'


options = {}
OptionParser.new do |opts|

  opts.banner = <<EOF
Usage: #{File.basename __FILE__} [options] XML [XML ..]

Generate a DS 2.0 CSV from legacy DS METS/MODS XML.

EOF

  opts.on('-o FILE', '--output-csv=FILE', "Name of the output CSV file [default: output.csv]") do |output|
    options[:output_csv] = output
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

xmls = ARGV.dup

abort 'Please provide an input XML' if xmls.empty?
cannot_find = xmls.reject { |f| File.exist?(f) }
abort "Can't find input XML: #{cannot_find.join '; ' }" unless cannot_find.empty?

DEFAULT_FIELD_SEP = '|'
DEFAULT_WORD_SEP  = ' '

output_csv = options[:output_csv] || 'output.csv'

CSV.open output_csv, "w", headers: true do |row|
  row << DS::HEADINGS

  xmls.each do |in_xml|
    xml = File.open(in_xml) { |f| Nokogiri::XML(f) }

    source_type                        = 'digital-scriptorium'
    holding_institution_as_recorded    = DS::DS10.extract_institution_name xml
    holding_institution                = DS::INSTITUTION_IDS_BY_NAME.fetch holding_institution_as_recorded, ''
    holding_institution_id_number      = DS::DS10.extract_institution_id xml
    link_to_holding_institution_record = DS::DS10.extract_link_to_inst_record xml
    production_date_encoded_008        = ''
    production_place_as_recorded       = DS::DS10.extract_production_place xml
    production_place                   = ''
    production_date_as_recorded        = DS::DS10.extract_date_as_recorded xml
    production_date                    = ''
    century                            = ''
    dated                              = DS::DS10.dated_by_scribe? xml
    uniform_title_240_as_recorded      = ''
    uniform_title_240_agr              = ''
    title_as_recorded_245              = DS::DS10.extract_title xml
    title_as_recorded_245_agr          = ''
    genre_as_recorded                  = ''
    subject_as_recorded                = ''
    author_as_recorded                 = DS::DS10.extract_text_name xml, 'author'
    author_as_recorded_agr             = ''
    artist_as_recorded                 = DS::DS10.extract_part_name xml, 'artist'
    artist_as_recorded_agr             = ''
    scribe_as_recorded                 = DS::DS10.extract_part_name xml, 'scribe'
    scribe_as_recorded_agr             = ''
    language_as_recorded               = DS::DS10.extract_language xml
    language                           = ''
    former_owner_as_recorded           = DS::DS10.extract_ownership xml
    former_owner_as_recorded_agr       = ''
    material                           = DS::DS10.extract_support xml
    material_as_recorded               = ''
    physical_description               = DS::DS10.extract_physical_description xml
    acknowledgements                   = DS::DS10.extract_acknowledgements xml

    data = { source_type:                        source_type,
             holding_institution:                holding_institution,
             holding_institution_as_recorded:    holding_institution_as_recorded,
             holding_institution_id_number:      holding_institution_id_number,
             link_to_holding_institution_record: link_to_holding_institution_record,
             production_date_encoded_008:        production_date_encoded_008,
             production_date:                    production_date,
             production_place_as_recorded:       production_place_as_recorded,
             production_place:                   production_place,
             century:                            century,
             dated:                              dated,
             production_date_as_recorded:        production_date_as_recorded,
             uniform_title_240_as_recorded:      uniform_title_240_as_recorded,
             uniform_title_240_agr:              uniform_title_240_agr,
             title_as_recorded_245:              title_as_recorded_245,
             title_as_recorded_245_agr:          title_as_recorded_245_agr,
             genre_as_recorded:                  genre_as_recorded,
             subject_as_recorded:                subject_as_recorded,
             author_as_recorded:                 author_as_recorded,
             author_as_recorded_agr:             author_as_recorded_agr,
             artist_as_recorded:                 artist_as_recorded,
             artist_as_recorded_agr:             artist_as_recorded_agr,
             scribe_as_recorded:                 scribe_as_recorded,
             scribe_as_recorded_agr:             scribe_as_recorded_agr,
             language_as_recorded:               language_as_recorded,
             language:                           language,
             former_owner_as_recorded:           former_owner_as_recorded,
             former_owner_as_recorded_agr:       former_owner_as_recorded_agr,
             material_as_recorded:               material_as_recorded,
             material:                           material,
             physical_description:               physical_description,
             acknowledgements:                   acknowledgements,
    }

    row << data
  end
end

puts "Wrote: #{output_csv}"