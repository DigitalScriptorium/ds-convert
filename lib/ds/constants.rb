module DS
  module Constants
    HEADINGS = %i{
ds_id
date_added
date_last_updated
source_type
cataloging_convention
holding_institution_ds_qid
holding_institution_as_recorded
holding_institution_id_number
holding_institution_shelfmark
link_to_holding_institution_record
iiif_manifest
production_place_as_recorded
production_place_ds_qid
production_date_as_recorded
production_date
century
century_aat
dated
title_as_recorded
title_as_recorded_agr
uniform_title_as_recorded
uniform_title_agr
standard_title_ds_qid
genre_as_recorded
genre_ds_qid
subject_as_recorded
subject_ds_qid
author_as_recorded
author_as_recorded_agr
author_ds_qid
artist_as_recorded
artist_as_recorded_agr
artist_ds_qid
scribe_as_recorded
scribe_as_recorded_agr
scribe_ds_qid
associated_agent_as_recorded
associated_agent_as_recorded_agr
associated_agent_ds_qid
former_owner_as_recorded
former_owner_as_recorded_agr
former_owner_ds_qid
language_as_recorded
language_ds_qid
material_as_recorded
material_ds_qid
physical_description
note
acknowledgments
data_processed_at
data_source_modified
source_file
}


    NESTED_COLUMNS = %i{ subject subject_label genre genre_label production_place production_place_label language language_label }
    # Institutions dependent on DS and their DS IDs
    # Some institutions have more than one collection
    #
    # conception    15
    # csl           12, 9
    # cuny           5
    # grolier       24
    # gts           23
    # indiana       40
    # kansas        30
    # nelsonatkins  46
    # nyu           25
    # providence    28
    # rutgers        6
    # ucb            1, 8, 11
    # wellesley     50



    INSTITUTION_DS_IDS = {
      1  => 'ucb',
      2  => 'harvard',
      3  => 'fordham',
      4  => 'freelib',
      5  => 'cuny',
      6  => 'rutgers',
      7  => 'ucd',
      8  => 'ucb',
      9  => 'csl',
      10 => 'ucr',
      11 => 'ucb',
      12 => 'csl',
      13 => 'sfu',
      14 => 'notredame',
      15 => 'conception',
      16 => 'columbia',
      17 => 'columbia',
      18 => 'columbia',
      19 => 'columbia',
      20 => 'columbia',
      21 => 'columbia',
      22 => 'columbia',
      23 => 'gts',
      24 => 'grolier',
      25 => 'nyu',
      26 => 'oberlin',
      27 => 'penn',
      28 => 'providence',
      29 => 'rome',
      30 => 'kansas',
      31 => 'jhopkins',
      32 => 'jhopkins',
      33 => 'jhopkins',
      34 => 'jhopkins',
      35 => 'walters',
      36 => 'pittsburgh',
      37 => 'txaustin',
      38 => 'uvm',
      39 => 'jtsa',
      40 => 'indiana',
      41 => 'nypl',
      42 => 'nypl',
      43 => 'huntington',
      44 => 'slu',
      45 => 'missouri',
      46 => 'nelsonatkins',
      47 => 'beinecke',
      48 => 'smith',
      50 => 'wellesley',
      52 => 'tufts'
    }.freeze

    TRAILING_PUNCTUATION_RE = %r{[,.:!?;[:space:]]+$}

    MAX_WIKIBASE_FIELD_LENGTH = 400

    INSTITUTIONS = INSTITUTION_DS_IDS.values.uniq.freeze

    MARC_XML = 'marc-xml'
    TEI_XML  = 'tei-xml'
    DS_CSV   = 'ds-csv'
    DS_METS  = 'ds-mets-xml'

    # source type list of all type names and normalized names; i.e.,
    # lower case names stripped of all whitespace and non-word characters
    VALID_SOURCE_TYPES = [
      MARC_XML,
      TEI_XML,
      DS_CSV,
      DS_METS
    ].freeze

    XML_NAMESPACES = {
      marc:  'http://www.loc.gov/MARC21/slim',
      mets:  'http://www.loc.gov/METS/',
      mods:  'http://www.loc.gov/mods/v3',
      rts:   'http://cosimo.stanford.edu/sdr/metsrights/',
      mix:   'http://www.loc.gov/mix/v10',
      xlink: 'http://www.w3.org/1999/xlink',
      xsi:   'http://www.w3.org/2001/XMLSchema-instance',
      xs:    'http://www.w3.org/2001/XMLSchema',
      xd:    'http://www.oxygenxml.com/ns/doc/xsl',
      tei:   'http://www.tei-c.org/ns/1.0'
    }

  end
end
