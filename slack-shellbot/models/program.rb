class Program
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :file_system
  field :message_ts, type: String

  def to_s
    id
  end

  # only one program per operating system
  index({ file_system_id: 1 }, unique: true)

  def message(_client, _data)
    fail NotImplementedError
  end

  def call(client, data)
    text = message(client, data)

    begin
      client.update(ts: message_ts, channel: data.channel, text: text)
      return
    rescue Slack::Web::Api::Error => e
      if e.message == 'message_not_found'
        update_attributes!(message_ts: nil)
      else
        raise e
      end
    end if message_ts && !destroyed?

    sent = client.say(channel: data.channel, text: text)
    update_attributes!(message_ts: sent.ts) if sent && sent.ts && !destroyed?
  end

  def terminate!
    destroy
  end
end
