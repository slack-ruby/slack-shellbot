class FileSystem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :channel, type: String
  belongs_to :team

  belongs_to :root_directory_entry, dependent: :destroy, inverse_of: nil
  belongs_to :current_directory_entry, class_name: 'DirectoryEntry', inverse_of: nil

  before_create :ensure_root_directory_entry!

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
    self.root_directory_entry = RootDirectoryEntry.create!
    self.current_directory_entry = root_directory_entry
  end
end
