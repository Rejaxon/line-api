module Line
  module Api
    module Endpoint
      module Message

        # https://developers.line.me/businessconnect/api-reference#sending_message
        def send_message(channel_access_token, to, content)
          to = [to] if to.is_a?(String)
          res = build_connection(:content_type => :json, 'X-Line-ChannelToken' => channel_access_token).post do |req|
            req.url('events')
            req.body = {
                to: to,
                toChannel: 1383378250,
                eventType: '138311608800106203',
                content: content.as_json
            }
          end
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body # {"failed"=>[], "messageId"=>"1463315591690", "timestamp"=>1463315591690, "version"=>1}
        end

        # https://developers.line.me/businessconnect/api-reference#sending_link_message
        def send_link_message(channel_access_token, to, template_id, preview_url: nil,
                              text_placeholder: {}, sub_text_placeholder: {}, link_text_placeholder: {},
                              alt_text_placeholder: {}, android_uri_placeholder: {}, iphone_uri_placeholder: {}, web_uri_placeholder: {})
          to = [to] if to.is_a?(String)
          text_placeholder = text_placeholder.map {|k, v| [k, CGI.escape_html(v)] }.to_h if text_placeholder.is_a?(Hash)
          res = build_connection(:content_type => :json, 'X-Line-ChannelToken' => channel_access_token).post do |req|
            req.url('events')
            req.body = {
                to: to,
                toChannel: 1341301715,
                eventType: '137299299800026303',
                content: {
                    templateId: template_id,
                    previewUrl: preview_url, # this > template image > channel icon
                    textParams: text_placeholder,
                    subTextParams: sub_text_placeholder,
                    altTextParams: alt_text_placeholder,
                    linkTextParams: link_text_placeholder,
                    aLinkUriParams: android_uri_placeholder,
                    iLinkUriParams: iphone_uri_placeholder,
                    linkUriParams: web_uri_placeholder,
                }
            }
          end
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body
        end

        # https://developers.line.me/businessconnect/api-reference#sending_multiple_messages
        def send_multiple_message(channel_access_token, to, multiple_contents)
          to = [to] if to.is_a?(String)
          res = build_connection(:content_type => :json, 'X-Line-ChannelToken' => channel_access_token).post do |req|
            req.url('events')
            req.body = {
                to: to,
                toChannel: 1383378250,
                eventType: '140177271400161403',
                content: {
                    messages: multiple_contents.map(&:as_json)
                }
            }
          end
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body
        end

      end
    end
  end
end
