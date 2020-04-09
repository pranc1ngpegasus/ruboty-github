module Ruboty
  module Adapters
    class GitHubWebhook < Base
      include Mem

      env :WEBHOOK_LISTEN_PORT, "Port number for webhook"

      def initialize(*args)
        super
        server
      end

      def run
        listen
      end

      private

      def listen
        server.start
      end

      def server
        server = WEBrick::HTTPServer.new({
          Port: webhook_listen_port,
        })

        server.mount_proc '/' do |req, res|
          robot.receive(body: req.body)
        end

        server
      end

      memoize :server

      def webhook_listen_port
        @webhook_listen_port ||= ENV['WEBHOOK_LISTEN_PORT']
      end
    end
  end
end
