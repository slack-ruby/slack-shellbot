require 'spec_helper'

describe FileSystem do
  let!(:fs) { Fabricate(:file_system) }
  it 'has a root directory' do
    expect(fs.root_directory_entry).to be_a(RootDirectoryEntry)
    expect(fs.reload.root_directory_entry).to be_a(RootDirectoryEntry)
  end
  context 'root' do
    let!(:root) { fs.root_directory_entry }
    it 'path' do
      expect(root.path).to eq '/'
    end
    it 'mkdir' do
      expect do
        root.mkdir('foobar')
      end.to change(DirectoryEntry, :count).by(1)
    end
    it 'mkdir .' do
      expect do
        root.mkdir('.')
      end.to raise_error Mongoid::Errors::Validations, /Invalid file or directory name./
    end
    it 'cd .' do
      fs.cd('.')
      expect(fs.current_directory_entry).to eq fs.root_directory_entry
    end
    it 'cd .,' do
      fs.cd('..')
      expect(fs.current_directory_entry).to eq fs.root_directory_entry
    end
    context 'with a directory' do
      let!(:dir) { root.mkdir('test') }
      it 'cd' do
        fs.cd('test')
        expect(fs.current_directory_entry.path).to eq '/test'
      end
      it 'rmdir' do
        expect do
          root.rmdir('test')
        end.to change(DirectoryEntry, :count).by(-1)
      end
      it 'enumerator' do
        expect(dir.map(&:to_s)).to eq ['.', '..']
        expect(root.map(&:to_s)).to eq ['.', '..', 'test']
      end
      it 'path' do
        expect(dir.path).to eq '/test'
      end
      context 'with a sub directory' do
        let!(:subdir) { dir.mkdir('foo') }
        it 'rmdir' do
          expect do
            dir.rmdir('foo')
          end.to change(DirectoryEntry, :count).by(-1)
        end
        it 'enumerator' do
          expect(subdir.map(&:to_s)).to eq ['.', '..']
          expect(dir.map(&:to_s)).to eq ['.', '..', 'foo']
          expect(root.map(&:to_s)).to eq ['.', '..', 'test']
        end
        it 'path' do
          expect(dir.path).to eq '/test'
          expect(subdir.path).to eq '/test/foo'
        end
        context 'inside a subdirectory' do
          before do
            fs.cd('test')
            fs.cd('foo')
          end
          it 'cd .' do
            fs.cd('.')
            expect(fs.current_directory_entry).to eq subdir
          end
          it 'cd .,' do
            fs.cd('..')
            expect(fs.current_directory_entry).to eq dir
          end
        end
      end
      context 'inside a directory' do
        before do
          fs.cd('test')
        end
        it 'cd .' do
          fs.cd('.')
          expect(fs.current_directory_entry).to eq dir
        end
        it 'cd .,' do
          fs.cd('..')
          expect(fs.current_directory_entry).to eq fs.root_directory_entry
        end
      end
    end
    context 'enumerator' do
      it 'count' do
        expect(root.count).to eq 2
      end
      it 'enumerator' do
        expect(root.map(&:to_s)).to eq ['.', '..']
      end
    end
  end
end
