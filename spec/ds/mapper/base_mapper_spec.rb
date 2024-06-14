# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DS::Mapper::BaseMapper do

  let(:marc_xml_dir) { fixture_path 'marc_xml' }

  ##
  # Test implementations of the BaseMapper methods
  class TestMapper < DS::Mapper::BaseMapper
    def extract_record entry; {}; end

    def map_record entry; {}; end

  end

  let(:timestamp) { Time.now }
  let(:base_mapper) {
    DS::Mapper::BaseMapper.new source_dir: marc_xml_dir, timestamp: timestamp, source: DS::Source::MarcXML.new
  }

  let(:test_mapper) {
    TestMapper.new source_dir: marc_xml_dir, timestamp: timestamp, source: DS::Source::MarcXML.new
  }

  let(:entry) { Object.new }

  context 'initialize' do
    it 'creates a new mapper' do
      expect(
        DS::Mapper::BaseMapper.new source_dir: marc_xml_dir, timestamp: timestamp, source: DS::Source::MarcXML.new
      ).to be_a DS::Mapper::BaseMapper
    end
  end

  context 'attributes' do
    context '#source_dir' do
      it 'is the source_dir' do
        expect(base_mapper.source_dir).to eq marc_xml_dir
      end
    end

    context '#timestamp' do
      it 'is the timestamp' do
        expect(base_mapper.timestamp).to eq timestamp
      end
    end
  end

  context '#extract_record' do
    it 'is a Mapper method' do
      expect(base_mapper.methods).to include :extract_record
    end

    it 'is not implemented' do
      expect {
        base_mapper.extract_record entry
      }.to raise_exception NotImplementedError
    end
  end

  context 'term string methods' do
    let(:recon_hashes) {
      [
        { recon_key_a: '1', recon_key_b: '4' },
        { recon_key_a: '2', recon_key_b: '5' },
        { recon_key_a: '3', recon_key_b: '6' }
      ]
    }

    context '#build_term_strings' do
      it 'is a Mapper method' do
        expect(base_mapper.methods).to include :build_term_strings
      end

      let(:column_map) {
        { import_csv_key_a: :recon_key_a, import_csv_key_b: :recon_key_b }
      }

      let(:expected_term_strings) {
        { import_csv_key_a: '1|2|3', import_csv_key_b: '4|5|6' }
      }

      it 'returns a hash of term strings' do
        expect(
          base_mapper.build_term_strings recon_hashes, column_map
        ).to eq expected_term_strings
      end
    end

    context '#build_term_string' do
      let(:recon_key) { :recon_key_a }
      let(:expected_term_string) { '1|2|3' }

      it 'is a Mapper method' do
        expect(base_mapper.methods).to include :build_term_string
      end

      it 'returns a term string' do
        expect(
          base_mapper.build_term_string recon_hashes, recon_key
        ).to eq expected_term_string
      end
    end
  end

  context '#map_record' do
    it 'is a Mapper method' do
      expect(base_mapper.methods).to include :map_record
    end

    it 'is not implemented' do
      expect {
        base_mapper.map_record entry
      }.to raise_exception NotImplementedError
    end
  end
end
