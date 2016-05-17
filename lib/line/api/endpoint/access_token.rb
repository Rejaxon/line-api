module Line
  module Api
    module Endpoint
      module AccessToken
        attr_accessor :oauth_cb_uri

        # @see https://developers.line.me/web-login/integrating-web-login#obtain_access_token
        def retrieve_access_token(oauth_code)
          res = build_connection(:content_type => :url_encoded).post do |req|
            req.url('oauth/accessToken')
            req.body = {
                grant_type: 'authorization_code',
                client_id: channel_id,
                client_secret: channel_secret,
                code: oauth_code,
                redirect_uri: oauth_cb_uri,
            }
          end
          error_code = res.body['error']
          raise Error::InvalidRequestToken, error_code if error_code == '412' || error_code == '415'
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          # expires_in: access_token発行時点からの有効秒数. expire parameterの仕様に合わせて返す
          res.body['expire'] = ((Time.now - Time.utc(1970, 1, 1)).to_i + res.body['expires_in'].to_i) * 1000
          res.body
        end

        # @see https://developers.line.me/restful-api/overview#refresh_token
        def reissue_access_token(old_access_token, refresh_token)
          headers = { :content_type => :url_encoded, 'X-Line-ChannelToken' => old_access_token }
          res = build_connection(headers).post do |req|
            req.url('oauth/accessToken')
            req.body = {
                refreshToken: refresh_token,
                channelSecret: channel_secret,
            }
          end
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body
        end

        # @see https://developers.line.me/restful-api/overview#check_token
        def check_access_token(access_token)
          conn = build_connection
          conn.authorization :Bearer, access_token
          res = conn.get { |req| req.url('oauth/verify') }
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body
        end

        def check_permission(access_token)
          conn = build_connection
          conn.authorization :Bearer, access_token
          res = conn.get { |req| req.url('permissions') }
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body # {"permissions":"[PROFILE_EMAIL, PROFILE_PHONE_NUMBER, PROFILE]"}
        end

      end
    end
  end
end
