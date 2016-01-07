require 'spec_helper'

describe Entry do
  context '#name' do
    it '.' do
      expect(Entry.new(name: '.')).to_not be_valid
      expect(Entry.new(name: '..')).to_not be_valid
      expect(Entry.new(name: '...')).to_not be_valid
    end
    it 'alphanumeric' do
      expect(Entry.new(name: 'foo')).to be_valid
      expect(Entry.new(name: 'foo bar')).to be_valid
      expect(Entry.new(name: '123')).to be_valid
      expect(Entry.new(name: 'abc123')).to be_valid
    end
  end
end
