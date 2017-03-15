class DirectoryEntry < Entry
  include Enumerable

  validate :validate_parent_directory_entry
  has_many :entries, dependent: :destroy

  def mkdir(name)
    DirectoryEntry.create!(
      name: name,
      parent_directory_entry: self,
      file_system: file_system
    )
  rescue Mongo::Error::OperationFailure => e
    if e.message.include?('E11000')
      raise Errno::EEXIST, name
    else
      raise e
    end
  end

  def rmdir(name)
    dir = entries.where(_type: 'DirectoryEntry', name: name).first
    raise Errno::ENOENT, name unless dir
    dir.destroy
    dir
  end

  def find(name)
    file = entries.where(_type: 'FileEntry', name: name).first
    raise Errno::ENOENT, name unless file
    file
  end

  def touch(name)
    entries.where(_type: 'FileEntry', name: name).first || FileEntry.create!(
      name: name,
      parent_directory_entry: self,
      file_system: file_system
    )
  end

  def write(name, data)
    file_entry = touch(name)
    file_entry.update_attributes!(data: data)
    file_entry
  end

  def rm(name)
    file = find(name)
    file.destroy
    file
  end

  def count
    2 + entries.count
  end

  def each
    return enum_for(:each) unless block_given?
    yield CurrentDirectoryEntry.new(self)
    yield ParentDirectoryEntry.new(self)
    entries.asc(:name).each do |dir|
      yield dir
    end
  end

  protected

  def validate_parent_directory_entry
    errors.add(:parent_directory_entry, 'Missing parent directory.') unless parent_directory_entry
  end
end
