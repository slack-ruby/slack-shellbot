class DirectoryEntry < Entry
  include Enumerable

  validate :validate_parent_directory_entry
  has_many :directory_entries, dependent: :destroy

  def mkdir(name)
    DirectoryEntry.create!(
      name: name,
      parent_directory_entry: self
    )
  end

  def rmdir(name)
    dir = directory_entries.where(name: name).first
    fail Errno::ENOENT, "#{path}/#{name}" unless dir
    dir.destroy
  end

  def count
    2 + directory_entries.count
  end

  def each
    return enum_for(:each) unless block_given?
    yield CurrentDirectoryEntry.new(self)
    yield ParentDirectoryEntry.new(self)
    directory_entries.each do |dir|
      yield dir
    end
  end

  protected

  def validate_parent_directory_entry
    errors.add(:parent_directory_entry, 'Missing parent directory.') unless parent_directory_entry
  end
end
