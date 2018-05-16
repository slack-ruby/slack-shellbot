require 'spec_helper'

describe Entry do
  let(:fs) { Fabricate(:file_system) }
  context '#name' do
    it '.' do
      expect(Entry.new(name: '.', file_system: fs)).to_not be_valid
      expect(Entry.new(name: '..', file_system: fs)).to_not be_valid
      expect(Entry.new(name: '...', file_system: fs)).to_not be_valid
    end
    it 'alphanumeric' do
      expect(Entry.new(name: 'foo', file_system: fs)).to be_valid
      expect(Entry.new(name: 'foo bar', file_system: fs)).to be_valid
      expect(Entry.new(name: '123', file_system: fs)).to be_valid
      expect(Entry.new(name: 'abc123', file_system: fs)).to be_valid
    end
  end
end
