# frozen_string_literal: true

RSpec.shared_examples "a recon type class" do |skips|

  context '.set_name' do
    let(:the_method) { :set_name }

    it 'implements the method' do
      expect(described_class).to respond_to the_method
    end

    it 'returns a symbol' do
      expect(described_class.send the_method).to be_a Symbol
    end
  end

  context '.csv_headers' do
    let(:the_method) { :recon_csv_headers }

    it 'implements the method' do
      expect(described_class).to respond_to the_method
    end

    it 'returns an array of strings' do
      expect(described_class.send the_method).to all be_a Symbol
    end
  end

  context '.lookup_columns' do
    let(:the_method) { :lookup_columns }

    it 'implements the method' do
      expect(described_class).to respond_to the_method
    end

    it 'returns an array of symbols' do
      expect(described_class.send the_method).to all be_a Symbol
    end
  end

  context '.key_columns' do
    let(:the_method) { :key_columns }

    it 'implements the method' do
      expect(described_class).to respond_to the_method
    end

    it 'returns an array of symbols' do
      expect(described_class.send the_method).to all be_a Symbol
    end
  end

  context '.as_recorded_column' do
    let(:the_method) { :as_recorded_column }

    it 'implements the method' do
      expect(described_class).to respond_to the_method
    end

    it 'returns a symbols' do
      expect(described_class.send the_method).to be_a Symbol
    end
  end

  context '.method_name' do
    let(:the_method) { :method_name }
    it 'implements the method' do
      expect(described_class).to respond_to the_method
    end

    it 'returns an array of symbols' do
      expect(described_class.send the_method).to all be_a Symbol
    end
  end

  context '.delimiter_map' do
    let(:the_method) { :delimiter_map }

    it 'implements the method' do
      expect(described_class).to respond_to the_method
    end

    it 'returns a hash' do
      expect(described_class.send the_method).to be_a Hash
    end
  end

  context '.balanced_columns', unless: skip?(skips, :balanced_columns) do
    let(:the_method) { :balanced_columns }

    it 'implements the method' do
      expect(described_class).to respond_to the_method
    end

    it 'is non-empty' do
      expect(described_class.send the_method).not_to be_blank
    end

    it 'returns an array of symbols' do
      expect(described_class.send the_method).to be_a(Hash)
    end
  end
end