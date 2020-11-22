class Team
  has_many :file_systems

  def fs
    @fs ||= FileSystemMap.new(self)
  end
end
