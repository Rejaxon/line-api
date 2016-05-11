require "faraday"
require "faraday_middleware"

require "line/api/configuration"
require "line/api/error"
require "line/api/endpoint"

module Line
  module Api
    class Client
      attr_accessor :base_url, :channel_id, :channel_secret, :oauth_cb_uri, :debug_mode

      def initialize(options = {})
        options = Line::Api::Configuration.config.merge(options)
        options.each { |attr, value| self.public_send("#{attr}=", value) }
      end

      include Line::Api::Endpoint

      class << self
        def method_missing(method, *args)
          self.new.public_send(method.to_s, *args)
        end
      end

      private

      # @see http://www.rubydoc.info/github/lostisland/faraday/Faraday/Connection
      # @see http://www.rubydoc.info/github/lostisland/faraday/Faraday/Request
      def build_connection(headers = {})
        Faraday.new base_url do |builder|
          headers.each do |k, v|
            next unless k.is_a?(String) && v.is_a?(String)
            builder.headers[k] = v.to_s
          end
          builder.request headers[:content_type] if headers[:content_type]
          builder.response :json, :content_type => /\bjson\Z/
          builder.response :logger if debug_mode
          builder.use :instrumentation
          builder.adapter Faraday.default_adapter
        end
      end

    end
  end
end
