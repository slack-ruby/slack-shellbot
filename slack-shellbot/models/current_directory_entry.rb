class CurrentDirectoryEntry
  attr_accessor :directory
  delegate :name, :directory_entries, to: :directory

  def to_s
    '.'
  end

  def initialize(directory)
    @directory = directory
  end
end
