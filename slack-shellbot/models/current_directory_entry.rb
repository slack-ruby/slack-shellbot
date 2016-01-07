class CurrentDirectoryEntry
  attr_accessor :directory
  delegate :name, :entries, to: :directory

  def to_s
    '.'
  end

  def initialize(directory)
    @directory = directory
  end
end
