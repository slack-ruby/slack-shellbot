class FileSystem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :channel, type: String
  validates_presence_of :channel
  belongs_to :team
  has_many :entries, dependent: :destroy

  belongs_to :root_directory_entry, inverse_of: nil
  belongs_to :current_directory_entry, class_name: 'DirectoryEntry', inverse_of: nil

  before_create :ensure_root_directory_entry!
  has_one :program

  def cd(name)
    dir = case name
          when '.'
            current_directory_entry
          when '..'
            current_directory_entry.parent_directory_entry || current_directory_entry
          else
            dir = current_directory_entry.entries.where(_type: 'DirectoryEntry', name: name).first
            raise Errno::ENOENT, Entry.combine_path(current_directory_entry.path, name) unless dir
            dir
          end
    update_attributes!(current_directory_entry: dir)
    dir
  end

  def to_s
    {
      channel: channel,
      pwd: current_directory_entry.path
    }.map do |k, v|
      "#{k}=#{v}" if v
    end.compact.join(', ')
  end

  private

  def ensure_root_directory_entry!
    self.root_directory_entry = RootDirectoryEntry.create!(file_system: self)
    self.current_directory_entry = root_directory_entry
  end
end
