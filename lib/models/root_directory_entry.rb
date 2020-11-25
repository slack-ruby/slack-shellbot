class RootDirectoryEntry < DirectoryEntry
  def initialize(attrs = {})
    attrs = attrs ? attrs.merge(name: '/') : { name: '/' }
    super(attrs)
  end

  protected

  def validate_name
    errors.add(:name, 'Invalid root directory name.') unless name == '/'
  end

  def validate_parent_directory_entry
    errors.add(:parent_directory_entry, 'Root cannot have a parent directory.') if parent_directory_entry
  end
end
