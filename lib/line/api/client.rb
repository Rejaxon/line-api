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

      def url_encoded_request(options = {})
        default_options = {
            request_content_type: :url_encoded,
            access_token: nil,
        }
        build_request(default_options.merge(options))
      end

      def json_request(options = {})
        default_options = {
            request_content_type: :json,
            access_token: channel_access_token,
        }
        build_request(default_options.merge(options))
      end

      def build_request(options = {})
        Faraday.new base_url do |builder|
          builder.headers['X-Line-ChannelToken'] = options[:access_token].to_s if options[:access_token]
          builder.request (options[:request_content_type] || :json)
          builder.response :json, :content_type => /\bjson\Z/
          builder.response :logger if debug_mode
          builder.use :instrumentation
          builder.adapter Faraday.default_adapter
        end
      end

    end
  end
end
