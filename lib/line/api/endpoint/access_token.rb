module Line
  module Api
    module Endpoint
      module AccessToken
        attr_accessor :oauth_cb_uri

        # https://developers.line.me/web-login/integrating-web-login#obtain_access_token
        def retrieve_access_token(oauth_code)
          res = url_encoded_request.post do |req|
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
          res.body
        end

        # https://developers.line.me/restful-api/overview#refresh_token
        def reissue_access_token(old_access_token, refresh_token)
          res = url_encoded_request(old_access_token).post do |req|
            req.url('oauth/accessToken')
            req.body = {
                refreshToken: refresh_token,
                channelSecret: channel_secret,
            }
          end
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body
        end

      end
    end
  end
end
