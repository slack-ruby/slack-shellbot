require 'spec_helper'

describe DirectoryEntry do
  let!(:dir) { Fabricate(:directory_entry) }
  context '#touch' do
    let!(:file) { dir.touch('test') }
    it 'is a file' do
      expect(file).to be_a FileEntry
    end
    it 'is attached ot the direcotry entry' do
      expect(file.parent_directory_entry).to eq dir
    end
    it 'is is included in count' do
      expect(dir.count).to eq 3
    end
    it 'rm' do
      expect {
        expect(dir.rm('test')).to be_a FileEntry
      }.to change(FileEntry, :count).by(-1)
    end
  end
end
