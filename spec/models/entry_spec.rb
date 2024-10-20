require 'spec_helper'

describe Entry do
  let(:fs) { Fabricate(:file_system) }

  describe '#name' do
    it '.' do
      expect(described_class.new(name: '.', file_system: fs)).not_to be_valid
      expect(described_class.new(name: '..', file_system: fs)).not_to be_valid
      expect(described_class.new(name: '...', file_system: fs)).not_to be_valid
    end

    it 'alphanumeric' do
      expect(described_class.new(name: 'foo', file_system: fs)).to be_valid
      expect(described_class.new(name: 'foo bar', file_system: fs)).to be_valid
      expect(described_class.new(name: '123', file_system: fs)).to be_valid
      expect(described_class.new(name: 'abc123', file_system: fs)).to be_valid
    end
  end
end
