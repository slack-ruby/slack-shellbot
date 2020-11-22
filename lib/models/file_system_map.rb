class FileSystemMap
  attr_reader :team

  def initialize(team)
    @team = team
  end

  # returns the current directory
  def [](channel)
    fs = FileSystem.where(team: team, channel: channel).first
    fs ||= FileSystem.create!(team: team, channel: channel)
    fs
  end
end
