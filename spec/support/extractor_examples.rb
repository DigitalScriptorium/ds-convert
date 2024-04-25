# frozen_string_literal: true

RSpec.shared_examples "an extractor" do

  context 'composite values' do
    context 'extract_titles' do
      let(:extraction_method) { :extract_titles }
      let(:composite_type) { DS::Extractor::Title }
      it 'returns an array of Title objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_languages' do
      let(:extraction_method) { :extract_languages }
      let(:composite_type) { DS::Extractor::Language }
      it 'returns an array of Language objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_materials' do
      let(:extraction_method) { :extract_materials }
      let(:composite_type) { DS::Extractor::Material }
      it 'returns an array of Material objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_authors' do
      let(:extraction_method) { :extract_authors }
      let(:composite_type) { DS::Extractor::Name }
      it 'returns an array of Name objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_scribes' do
      let(:extraction_method) { :extract_scribes }
      let(:composite_type) { DS::Extractor::Name }
      it 'returns an array of Name objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_former_owners' do
      let(:extraction_method) { :extract_former_owners }
      let(:composite_type) { DS::Extractor::Name }
      it 'returns an array of Name objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_genres' do
      let(:extraction_method) { :extract_genres }
      let(:composite_type) { DS::Extractor::Genre }
      it 'returns an array of Genre objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_subjects' do
      let(:extraction_method) { :extract_subjects }
      let(:composite_type) { DS::Extractor::Subject }
      it 'returns an array of Subject objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_named_subjects' do
      let(:extraction_method) { :extract_named_subjects }
      let(:composite_type) { DS::Extractor::Subject }
      it 'returns an array of Subject objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end

    context 'extract_places' do
      let(:extraction_method) { :extract_places }
      let(:composite_type) { DS::Extractor::Place }
      it 'returns an array of Place objects' do
        expect(
          described_class.send extraction_method, record
        ).to include an_instance_of composite_type
      end
    end
  end

  context 'extract_cataloging_convention' do
    let(:extract_method) { :extract_cataloging_convention }
    let(:return_type) { String }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_titles_as_recorded' do
    let(:extract_method) { :extract_titles_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_titles_as_recorded_agr' do
    let(:extract_method) { :extract_titles_as_recorded_agr }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_uniform_titles_as_recorded' do
    let(:extract_method) { :extract_uniform_titles_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_uniform_titles_as_recorded_agr' do
    let(:extract_method) { :extract_uniform_titles_as_recorded_agr }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_recon_titles' do
    let(:extract_method) { :extract_recon_titles }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_production_date_as_recorded' do
    let(:extract_method) { :extract_production_date_as_recorded }
    let(:return_type) { String }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_date_range' do
    let(:extract_method) { :extract_date_range }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_production_places_as_recorded' do
    let(:extract_method) { :extract_production_places_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_recon_places' do
    let(:extract_method) { :extract_recon_places }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_languages_as_recorded' do
    let(:extract_method) { :extract_languages_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_authors_as_recorded' do
    let(:extract_method) { :extract_authors_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_authors_as_recorded_agr' do
    let(:extract_method) { :extract_authors_as_recorded_agr }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_artists_as_recorded' do
    let(:extract_method) { :extract_artists_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_artists_as_recorded_agr' do
    let(:extract_method) { :extract_artists_as_recorded_agr }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_scribes_as_recorded' do
    let(:extract_method) { :extract_scribes_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_scribes_as_recorded_agr' do
    let(:extract_method) { :extract_scribes_as_recorded_agr }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_former_owner_as_recorded' do
    let(:extract_method) { :extract_former_owners_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_former_owner_as_recorded_agr' do
    let(:extract_method) { :extract_former_owners_as_recorded_agr }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_recon_names' do
    let(:extract_method) { :extract_recon_names }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_physical_description' do
    let(:extract_method) { :extract_physical_description }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_material_as_recorded' do
    let(:extract_method) { :extract_material_as_recorded }
    let(:return_type) { String }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_subjects_as_recorded' do
    let(:extract_method) { :extract_subjects_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_named_subjects_as_recorded' do
    let(:extract_method) { :extract_named_subjects_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_all_subjects_as_recorded' do
    let(:extract_method) { :extract_all_subjects_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_recon_subjects' do
    let(:extract_method) { :extract_recon_subjects }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_genres_as_recorded' do
    let(:extract_method) { :extract_genres_as_recorded }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_recon_genres' do
    let(:extract_method) { :extract_recon_genres }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_notes' do
    let(:extract_method) { :extract_notes }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end

  context 'extract_date_source_modified' do
    let(:extract_method) { :extract_date_source_modified }
    let(:return_type) { String }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end

    it 'is in YYYY-MM-DD format' do
      expect(described_class.send extract_method, record).to match /^\d{4}-\d{2}-\d{2}$/
    end
  end

  context 'extract_acknowledgments' do
    let(:extract_method) { :extract_acknowledgments }
    let(:return_type) { Array }

    it 'responds to the method' do
      expect(described_class).to respond_to extract_method
    end

    it 'returns the expected type' do
      expect(described_class.send extract_method, record).to be_a return_type
    end
  end



end
