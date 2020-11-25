SlackRubyBotServer::Events.configure do |config|
  config.on :event, 'event_callback', 'message' do |event|
    # SlackShellbot::Commands::Base.logger.info event
    # SlackShellbot::Commands::Base.logger.info "SUBTYPE: #{event['event']['subtype']}"
    next true if event['event']['subtype'] # updates, etc.
    # SlackShellbot::Commands::Base.logger.info "AUTH: #{event['authorizations'][0]['user_id']} vs. #{event['event']['user']}"
    next true if event['authorizations'][0]['user_id'] == event['event']['user'] # self

    data = Hashie::Mash.new(event['event'])
    # SlackShellbot::Commands::Base.logger.info "MESSAGE: #{data.text}"
    team = Team.where(team_id: event['team_id']).first
    next true unless team

    client = SlackShellbot::Web::Client.new(token: team.token, team: team)
    SlackShellbot::Commands::Base.call(client, data)
    true
  end
end
