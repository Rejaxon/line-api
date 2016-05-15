require_relative 'base'

module Line
  module Api
    module Content
      # https://developers.line.me/businessconnect/api-reference#sending_message_image
      class Image < Base
        CONTENT_TYPE = 2
        attr_accessor :url, :thumbnail_url

        def as_json
          super.merge(
              {
                  originalContentUrl: url, # 1024x1024以下のjpeg
                  previewImageUrl: thumbnail_url, # 240×240以下のjpeg. 2016/05/15時点は、image_urlと同サイズの900×900で送信成功
              })
        end
      end
    end
  end
end
