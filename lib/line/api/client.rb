require "faraday"
require "faraday_middleware"

require "line/api/configuration"
require "line/api/error"
require "line/api/endpoint"

module Line
  module Api
    class Client
      attr_accessor :base_url, :channel_id, :channel_secret, :channel_access_token, :oauth_cb_uri,
                    :debug_mode

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

      def url_encoded_request(access_token = nil)
        req = request(access_token)
        req.request :url_encoded
        return req
      end

      def json_request(access_token = nil)
        access_token ||= channel_access_token
        req = request(access_token)
        req.request :json
        return req
      end

      def request(access_token)
        Faraday.new base_url do |builder|
          builder.headers['X-Line-ChannelToken'] = access_token unless access_token.nil?
          builder.response :json, :content_type => /\bjson\Z/
          builder.response :logger if debug_mode
          builder.use :instrumentation
          builder.adapter Faraday.default_adapter
        end
      end

    end
  end
end
