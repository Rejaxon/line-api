module Line
  module Api
    module Endpoint
      module Profile

        # user_access_token: email/phoneの取得処理は取得後、1時間制限以内
        def get_profile(user_access_token)
          conn = build_connection
          conn.authorization :Bearer, user_access_token
          res = conn.get { |req| req.url('profile') }
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body # {"permissions":"[PROFILE_EMAIL, PROFILE_PHONE_NUMBER, PROFILE]"}
        end

        # https://developers.line.me/businessconnect/api-reference#getting_user_profile_information
        def get_profiles(channel_access_token, mid_list)
          mid_list = [mid_list] if mid_list.is_a?(String)
          res = build_connection(:content_type => :json, 'X-Line-ChannelToken' => channel_access_token).post do |req|
            req.url('events')
            req.body = {
                mids: mid_list.join(',')
            }
          end
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body
        end

      end
    end
  end
end
