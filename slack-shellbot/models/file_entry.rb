class FileEntry < Entry
  field :data

  def to_s
    "#{name}, #{size} byte(s)"
  end

  def size
    data ? data.size : 0
  end
end
