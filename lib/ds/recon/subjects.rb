require 'nokogiri'
require_relative 'recon_type'

module Recon
  ##
  # Extract subjects for reconciliation CSV output.
  #
  # NOTE: Each source subject extraction method should return a two dimensional
  # array:
  #
  #     [["Islamic law--Early works to 1800", ""],
  #       ["Malikites--Early works to 1800", ""],
  #       ["Islamic law", ""],
  #       ["Malikites", ""],
  #       ["Arabic language--Grammar--Early works to 1800", ""],
  #       ["Arabic language--Grammar", ""],
  #       ...
  #       ]
  #
  # The two values are `subject_as_recorded` and `source_authority_uri`. The
  # second of these is present when the source record provides an accompanying
  # URI. This is rare. Sources the lack a URI should return the as recorded
  # value and `""` (the empty string) for the `source_authority_uri` as shown
  # above.
  #
  class Subjects

    extend DS::Util
    include ReconType

    SET_NAME = :subjects

    CSV_HEADERS = %i{
      subject_as_recorded
      subfield_codes
      vocab
      source_authority_uri
      authorized_label
      structured_value
    }.freeze

    LOOKUP_COLUMNS = %i{
      authorized_label
      structured_value
      ds_qid
    }

    KEY_COLUMNS = %i{
      subject_as_recorded
      vocabulary
    }
    # TODO: ADD subfield_codes as key column


    AS_RECORDED_COLUMN = :subject_as_recorded

    DELIMITER_MAP = { '|' => ';' }

    def self.add_recon_values rows
      rows.each do |row|
        term, _ = row
        row << _lookup_single(term, from_column: 'authorized_label')
        row << _lookup_single(term, from_column: 'structured_value')
      end
    end

    def self.from_marc files, tags: []
      data = []
      process_xml files,remove_namespaces: true do |xml|
        xml.xpath('//record').each do |record|
          data += DS::Extractor::MarcXml.extract_recon_subjects record, tags: tags
        end
      end
      add_recon_values data
      Recon.sort_and_dedupe data
    end

    def self.lookup terms, from_column: 'structured_value'
      terms.map { |term|
        _lookup_single term, from_column: from_column
      }
    end

    def self.from_mets files
      data = []
      process_xml files do |xml|
        data += DS::Extractor::DsMetsXml.extract_recon_subjects(xml)
      end
      add_recon_values data
      Recon.sort_and_dedupe data
    end

    def self.from_tei files
      data = []
      process_xml files, remove_namespaces: true do |xml|
        data += DS::Extractor::TeiXml.extract_recon_subjects xml
      end
      add_recon_values data
      Recon.sort_and_dedupe data
    end

    def self._lookup_single term, from_column:
      uris = Recon.lookup(SET_NAME, value: term, column: from_column)
      uris.to_s.gsub '|', ';'
    end
  end
end
