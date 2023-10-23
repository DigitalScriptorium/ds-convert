# frozen_string_literal: true

module DS
  module Mapper
    class OPennTEIMapper
      attr_reader :timestamp
      attr_reader :source_file
      attr_reader :record

      def initialize(record:, timestamp:, source_file:)
        @record         = record
        @timestamp      = timestamp
        @source_file    = source_file
      end

      def map_record
        source_type                        = 'openn-tei'
        holding_institution_as_recorded    = DS::OPennTEI.extract_holding_institution record
        holding_institution                = DS::Institutions.find_qid holding_institution_as_recorded
        holding_institution_id_number      = DS::OPennTEI.extract_holding_institution_id_nummber record
        holding_institution_shelfmark      = DS::OPennTEI.extract_shelfmark record
        link_to_holding_institution_record = record.xpath('//altIdentifier[@type="resource"][1]').text.strip
        production_place_as_recorded       = record.xpath('//origPlace/text()').map(&:to_s).join '|'
        production_place                   = Recon::Places.lookup production_place_as_recorded.split('|'), from_column: 'structured_value'
        production_place_label             = Recon::Places.lookup production_place_as_recorded.split('|'), from_column: 'authorized_label'
        production_date_as_recorded        = DS::OPennTEI.extract_production_date record, range_sep: '-'
        production_date                    = DS::OPennTEI.extract_production_date record, range_sep: '^'
        century                            = DS.transform_dates_to_centuries production_date
        century_aat                        = DS.transform_centuries_to_aat century
        title_as_recorded                  = DS::OPennTEI.extract_title_as_recorded(record).join '|'
        title_as_recorded_agr              = DS::OPennTEI.extract_title_as_recorded_agr(record).join '|'
        standard_title                     = Recon::Titles.lookup(title_as_recorded.split('|'), column: 'authorized_label').join('|')
        genre_as_recorded                  = DS::OPennTEI.extract_genre_as_recorded(record).join '|'
        genre_vocabulary                   = '' # DS::OPennTEI.extract_genre_vocabulary record
        genre                              = Recon::Genres.lookup genre_as_recorded.split('|'), genre_vocabulary.split('|'), from_column: 'structured_value'
        genre_label                        = Recon::Genres.lookup genre_as_recorded.split('|'), genre_vocabulary.split('|'), from_column: 'authorized_label'
        subject_as_recorded                = DS::OPennTEI.extract_subject_as_recorded(record).join '|'
        subject                            = Recon::AllSubjects.lookup subject_as_recorded.split('|'), from_column: 'structured_value'
        subject_label                      = Recon::AllSubjects.lookup subject_as_recorded.split('|'), from_column: 'authorized_label'

        author_as_recorded                 = DS::OPennTEI.extract_authors(record).join '|'
        author_as_recorded_agr             = DS::OPennTEI.extract_authors_agr(record).join '|'
        author_wikidata                    = Recon::Names.lookup(author_as_recorded.split('|'), column: 'structured_value').join '|'
        author                             = ''
        author_instance_of                 = Recon::Names.lookup(author_as_recorded.split('|'), column: 'instance_of').join '|'
        author_label                       = Recon::Names.lookup(author_as_recorded.split('|'), column: 'authorized_label').join '|'
        artist_as_recorded                 = DS::OPennTEI.extract_artists(record).join '|'
        artist_as_recorded_agr             = DS::OPennTEI.extract_artists_agr(record).join '|'
        artist_wikidata                    = Recon::Names.lookup(artist_as_recorded.split('|'), column: 'structured_value').join '|'
        artist                             = ''
        artist_instance_of                 = Recon::Names.lookup(artist_as_recorded.split('|'), column: 'instance_of').join '|'
        artist_label                       = Recon::Names.lookup(artist_as_recorded.split('|'), column: 'authorized_label').join '|'
        scribe_as_recorded                 = DS::OPennTEI.extract_scribes(record).join '|'
        scribe_as_recorded_agr             = DS::OPennTEI.extract_scribes_agr(record).join '|'
        scribe_wikidata                    = Recon::Names.lookup(scribe_as_recorded.split('|'), column: 'structured_value').join '|'
        scribe                             = ''
        scribe_instance_of                 = Recon::Names.lookup(scribe_as_recorded.split('|'), column: 'instance_of').join '|'
        scribe_label                       = Recon::Names.lookup(scribe_as_recorded.split('|'), column: 'authorized_label').join '|'
        language_as_recorded               = DS::OPennTEI.extract_language_as_recorded record
        language                           = Recon::Languages.lookup language_as_recorded, from_column: 'structured_value'
        language_label                     = Recon::Languages.lookup language_as_recorded, from_column: 'authorized_label'
        illuminated_initials               = ''
        miniatures                         = ''
        former_owner_as_recorded           = DS::OPennTEI.extract_former_owners(record).join '|'
        former_owner_as_recorded_agr       = DS::OPennTEI.extract_former_owners_agr(record).join '|'
        former_owner_wikidata              = Recon::Names.lookup(former_owner_as_recorded.split('|'), column: 'structured_value').join '|'
        former_owner                       = ''
        former_owner_instance_of           = Recon::Names.lookup(former_owner_as_recorded.split('|'), column: 'instance_of').join '|'
        former_owner_label                 = Recon::Names.lookup(former_owner_as_recorded.split('|'), column: 'authorized_label').join '|'
        material_as_recorded               = record.xpath('/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/supportDesc/support/p').text
        material                           = Recon::Materials.lookup material_as_recorded.split('|'), column: 'structured_value'
        material_label                     = Recon::Materials.lookup material_as_recorded.split('|'), column: 'authorized_label'
        physical_description               = DS::OPennTEI.extract_physical_description record
        acknowledgements                   = ''
        extent_as_recorded                 = record.xpath('/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/supportDesc/extent/text()').text.strip
        note                               = DS::OPennTEI.extract_note(record).join '|'
        data_processed_at                  = timestamp
        data_source_modified               = DS::OPennTEI.source_modified record

        # TODO: BiblioPhilly MSS have keywords (not subjects, genre); include them?

        {
          ds_id:                              nil,
          date_added:                         nil,
          date_last_updated:                  nil,
          cataloging_convention:              nil,
          iiif_manifest:                      nil,
          dated:                              nil,
          source_type:                        source_type,
          holding_institution:                holding_institution,
          holding_institution_as_recorded:    holding_institution_as_recorded,
          holding_institution_id_number:      holding_institution_id_number,
          holding_institution_shelfmark:      holding_institution_shelfmark,
          link_to_holding_institution_record: link_to_holding_institution_record,
          production_place_as_recorded:       production_place_as_recorded,
          production_place:                   production_place,
          production_place_label:             production_place_label,
          production_date_as_recorded:        production_date_as_recorded,
          production_date:                    production_date,
          century:                            century,
          century_aat:                        century_aat,
          title_as_recorded:                  title_as_recorded,
          title_as_recorded_agr:              title_as_recorded_agr,
          uniform_title_as_recorded:          nil,
          uniform_title_agr:                  nil,
          standard_title:                     standard_title,
          genre_as_recorded:                  genre_as_recorded,
          genre:                              genre,
          genre_label:                        genre_label,
          subject_as_recorded:                subject_as_recorded,
          subject:                            subject,
          subject_label:                      subject_label,
          author_as_recorded:                 author_as_recorded,
          author_as_recorded_agr:             author_as_recorded_agr,
          author_wikidata:                    author_wikidata,
          author:                             author,
          author_instance_of:                 author_instance_of,
          author_label:                       author_label,
          artist_as_recorded:                 artist_as_recorded,
          artist_as_recorded_agr:             artist_as_recorded_agr,
          artist_wikidata:                    artist_wikidata,
          artist:                             artist,
          artist_instance_of:                 artist_instance_of,
          artist_label:                       artist_label,
          scribe_as_recorded:                 scribe_as_recorded,
          scribe_as_recorded_agr:             scribe_as_recorded_agr,
          scribe_wikidata:                    scribe_wikidata,
          scribe:                             scribe,
          scribe_instance_of:                 scribe_instance_of,
          scribe_label:                       scribe_label,
          associated_agent_as_recorded:       nil,
          associated_agent_as_recorded_agr:   nil,
          associated_agent:                   nil,
          associated_agent_label:             nil,
          associated_agent_wikidata:          nil,
          associated_agent_instance_of:       nil,
          language_as_recorded:               language_as_recorded,
          language:                           language,
          language_label:                     language_label,
          illuminated_initials:               illuminated_initials,
          miniatures:                         miniatures,
          former_owner_as_recorded:           former_owner_as_recorded,
          former_owner_as_recorded_agr:       former_owner_as_recorded_agr,
          former_owner_wikidata:              former_owner_wikidata,
          former_owner:                       former_owner,
          former_owner_instance_of:           former_owner_instance_of,
          former_owner_label:                 former_owner_label,
          material:                           material,
          material_as_recorded:               material_as_recorded,
          material_label:                     material_label,
          physical_description:               physical_description,
          acknowledgements:                   acknowledgements,
          extent_as_recorded:                 extent_as_recorded,
          note:                               note,
          data_processed_at:                  data_processed_at,
          data_source_modified:               data_source_modified,
          source_file:                        source_file
        }
      end
    end
  end
end