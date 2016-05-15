module Line
  module Api
    module Content
      # https://developers.line.me/businessconnect/api-reference#sending_message_audio
      class Audio < Base
        CONTENT_TYPE = 4
        attr_accessor :url, :ms

        def to_json
          super.merge(
              {
                  originalContentUrl: url,
                  contentMetadata: { AUDLEN: ms },
              })
        end
      end
    end
  end
end
