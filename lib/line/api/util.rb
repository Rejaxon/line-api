require 'openssl'
require 'base64'

module Line
  module Api
    class Util

      class << self
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
