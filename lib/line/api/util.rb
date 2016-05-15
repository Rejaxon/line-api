require 'openssl'
require 'base64'

module Line
  module Api
    class Util

      class << self

        # validate_signature(request.raw_post, request.headers)
        def validate_signature(request_body_string, headers)
          channel_secret = Line::Api::Configuration.channel_secret
          hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, channel_secret, request_body_string)
          signature = Base64.strict_encode64(hash)
          signature == headers['X-LINE-CHANNELSIGNATURE']
        end

        # for Channel Web Application
        def retrieve_access_token_from_encrypted_string(encrypted_string)
          cipher = OpenSSL::Cipher::Cipher.new('AES-128-ECB')
          cipher.decrypt
          cipher.key = [Line::Api::Configuration.channel_secret].pack('H*')
          decoded = Base64.decode64(encrypted_string)
          decrypted = cipher.update(decoded) + cipher.final
          mid, access_token, expire, refresh_token = decrypted.split('.')
          return mid, access_token, expire, refresh_token
        end
      end

    end
  end
end
