require 'nokogiri'

module Recon
  module Type
    class Places

      extend DS::Util
      include ReconType

      SET_NAME = :places

      RECON_CSV_HEADERS = %i{ place_as_recorded authorized_label structured_value ds_qid}

      LOOKUP_COLUMNS = %i{
      authorized_label
      structured_value
      ds_qid
    }

    KEY_COLUMNS = %i{ place_as_recorded }

    AS_RECORDED_COLUMN = :place_as_recorded

    DELIMITER_MAP = { '|' => ';' }

    METHOD_NAME = %i{ extract_places }

    BALANCED_COLUMNS = { places: %i{ structured_value authorized_label } }

    def self.lookup places, from_column: 'structured_value'
      places.map { |place|
        key_values = get_key_values place.to_h
        place_uris = Recon.lookup_single SET_NAME, key_values: key_values, column: from_column
        place_uris.to_s.gsub '|', ';'
      }
    end

    end
  end
end