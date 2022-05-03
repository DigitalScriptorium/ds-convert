require 'nokogiri'

module Recon
  class GenreTerms
    def self.from_marc files
      data = []
      files.each do |in_xml|
        xml = File.open(in_xml) { |f| Nokogiri::XML(f) }
        xml.remove_namespaces!
        xml.xpath('//record').each do |record|
          data += DS::MarcXML.extract_genre_sets record, sub_sep: '--'
        end
      end
      Recon.sort_and_dedupe data
    end

    def self.from_mets files
      raise NotImplementedError
    end

    def self.from_tei files
      raise NotImplementedError
    end
  end
end