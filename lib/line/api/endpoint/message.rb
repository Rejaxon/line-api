module Line
  module Api
    module Endpoint
      module Message

        # https://developers.line.me/businessconnect/api-reference#sending_message_text
        def send_text_message(channel_access_token, to, text, to_type = 1)
          send_message(channel_access_token, to, text_content(text, to_type))
        end

        # https://developers.line.me/businessconnect/api-reference#sending_message_image
        def send_image_message(channel_access_token, to, image_url, thumbnail_url, to_type = 1)
          send_message(channel_access_token, to, image_content(image_url, thumbnail_url, to_type))
        end

        # https://developers.line.me/businessconnect/api-reference#sending_message_video
        def send_movie_message(channel_access_token, to, movie_url, thumbnail_url, to_type = 1)
          send_message(channel_access_token, to, movie_content(movie_url, thumbnail_url, to_type))
        end

        # https://developers.line.me/businessconnect/api-reference#sending_message_audio
        def send_audio_message(channel_access_token, to, audio_url, audio_ms_length, to_type = 1)
          send_message(channel_access_token, to, audio_content(audio_url, audio_ms_length, to_type))
        end

        # https://developers.line.me/businessconnect/api-reference#sending_message_location
        def send_location_message(channel_access_token, to, title, latitude, longitude, to_type = 1)
          send_message(channel_access_token, to, location_content(title, latitude, longitude, to_type))
        end

        # https://developers.line.me/businessconnect/api-reference#sending_message
        def send_message(channel_access_token, to, content)
          to = [to] if to.is_a?(String)
          res = build_connection(:content_type => :json, 'X-Line-ChannelToken' => channel_access_token).post do |req|
            req.url('events')
            req.body = {
                to: to,
                toChannel: 1383378250,
                eventType: '138311608800106203',
                content: content
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
                    messages: multiple_contents
                }
            }
          end
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body
        end

        def text_content(text, to_type)
          {
              contentType: 1,
              toType: to_type,
              text: text,
          }
        end

        def image_content(image_url, thumbnail_url, to_type)
          {
              contentType: 2,
              toType: to_type,
              originalContentUrl: image_url, # 1024x1024以下のjpeg
              previewImageUrl: thumbnail_url, # 240×240以下のjpeg. 2016/05/15時点は、image_urlと同サイズの900×900で送信成功
          }
        end

        def movie_content(movie_url, thumbnail_url, to_type)
          {
              contentType: 3,
              toType: to_type,
              originalContentUrl: movie_url,
              previewImageUrl: thumbnail_url,
          }
        end

        def audio_content(audio_url, audio_ms_length, to_type)
          {
              contentType: 4,
              toType: to_type,
              originalContentUrl: audio_url,
              contentMetadata: { AUDLEN: audio_ms_length },
          }
        end

        def location_content(title, latitude, longitude, to_type)
          {
              contentType: 7,
              toType: to_type,
              text: title,
              location: {
                  title: title,
                  latitude: latitude,
                  longitude: longitude,
              },
          }
        end

      end
    end
  end
end
