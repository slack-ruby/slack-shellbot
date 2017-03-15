module Api
  class Middleware
    def initialize
      @rack_static = Rack::Static.new(
        -> { [404, {}, []] },
        urls: ['/', '/img', '/scripts'],
        root: File.expand_path('../../../public', __FILE__),
        index: 'index.html'
      )
    end

    def self.logger
      @logger ||= begin
        $stdout.sync = true
        Logger.new(STDOUT)
      end
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: [:get, :post]
          end
        end

        # rewrite HAL links to make them clickable in a browser
        use Rack::Rewrite do
          r302 %r{(\/[\w\/]*\/)(%7B|\{)?(.*)(%7D|\})}, '$1'
        end

        use Rack::Robotz, 'User-Agent' => '*', 'Disallow' => '/'

        run Api::Middleware.new
      end.to_app
    end

    def call(env)
      response = Api::Endpoints::RootEndpoint.call(env)
      response = @rack_static.call(env) if response[1]['X-Cascade'] == 'pass'
      response
    end
  end
end
