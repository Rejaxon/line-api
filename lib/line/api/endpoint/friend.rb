module Line
  module Api
    module Endpoint
      module Friend

        # https://developers.line.me/businessconnect/api-reference#add_oa_as_friend
        def add_friend(user_access_token)
          res = build_request(:content_type => :json, 'X-Line-ChannelToken' => user_access_token).post do |req|
            req.url('officialaccount/contacts')
          end
          # ユーザー設定によって自動追加できないケースで通信エラーではない. ユーザーにLINEアプリからの設定へ誘導
          return false if res.status == 409
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body # { "result": "OK" }
        end

      end
    end
  end
end
