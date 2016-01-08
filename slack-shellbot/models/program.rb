class Program
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :file_system

  def to_s
    id
  end

  # only one program per operating system
  index({ file_system_id: 1 }, unique: true)

  def message(_client, _data)
    fail NotImplementedError
  end

  def terminate!
    destroy
  end
end
