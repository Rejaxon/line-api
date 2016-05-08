require "active_support/configurable"

module Line
  module Api
    class Configuration
      include ::ActiveSupport::Configurable
      config_accessor :base_url, :channel_id, :channel_secret, :channel_access_token, :oauth_cb_uri,
                      :debug_mode

      configure do |config|
        config.base_url = 'https://api.line.me/v1/'
      end
    end
  end
end
