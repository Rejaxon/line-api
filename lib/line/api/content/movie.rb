require_relative 'base'

module Line
  module Api
    module Content
      # https://developers.line.me/businessconnect/api-reference#sending_message_video
      class Movie < Base
        CONTENT_TYPE = 3
        attr_accessor :url, :thumbnail_url

        def as_json
          super.merge(
              {
                  originalContentUrl: url,
                  previewImageUrl: thumbnail_url,
              })
        end
      end
    end
  end
end
