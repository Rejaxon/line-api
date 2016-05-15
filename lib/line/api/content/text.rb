module Line
  module Api
    module Content
      # https://developers.line.me/businessconnect/api-reference#sending_message_text
      class Text < Base
        CONTENT_TYPE = 1
        attr_accessor :text

        def to_json
          super.merge(
              {
                  text: text
              })
        end
      end
    end
  end
end
