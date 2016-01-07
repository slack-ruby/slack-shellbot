class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  def to_s
    name
  end

  validates_presence_of :name
  validate :validate_name

  belongs_to :parent_directory_entry, class_name: 'DirectoryEntry', inverse_of: :directories, index: true
  index({ name: 1, parent_directory_entry_id: 1 }, unique: true)

  def self.combine_path(path, name)
    [path, name].join(path[-1] == '/' ? nil : '/')
  end

  def path
    parent_directory_entry ? Entry.combine_path(parent_directory_entry.path, name) : name
  end

  protected

  def validate_name
    errors.add(:name, 'Invalid file or directory name.') unless name && name.match(/\A([^\W]|[\.-_%#\ +])+\z/)
  end
end
