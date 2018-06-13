module SlackShellbot
  class App < SlackRubyBotServer::App
    include Celluloid

    def after_start!
      every 60 * 60 do
        ping_teams!
      end
    end

    private

    def ping_teams!
      Team.active.each do |team|
        begin
          ping = team.ping!
          next if ping[:presence].online
          logger.warn "DOWN: #{team}"
          after 60 do
            ping = team.ping!
            unless ping[:presence].online
              logger.info "RESTART: #{team}"
              SlackShellbot::Service.instance.start!(team)
            end
          end
        rescue StandardError => e
          logger.warn "Error pinging team #{team}, #{e.message}."
        end
      end
    end
  end
end
