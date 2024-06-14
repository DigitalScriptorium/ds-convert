require 'nokogiri'

module Recon

  module Type
    class Materials

      extend DS::Util
      include ReconType

      SET_NAME = :materials

      RECON_CSV_HEADERS = %i{
      material_as_recorded
      authorized_label
      structured_value
      ds_qid
    }

      LOOKUP_COLUMNS = %i{
      authorized_label
      structured_value
      ds_qid
    }

      KEY_COLUMNS = %i{
      material_as_recorded
    }

      METHOD_NAME = %i{ extract_materials }

      SUBSET_COLUMN = nil

      AS_RECORDED_COLUMN = :material_as_recorded

      DELIMITER_MAP = { '|' => ';' }

      BALANCED_COLUMNS = { materials: %w{ structured_value authorized_label } }

      def self.lookup materials, column:
        materials.map { |material|
          material_uris = Recon.lookup_single SET_NAME, value: material, column: column
          material_uris.to_s.gsub '|', ';'
        }
      end

    end
  end
end
