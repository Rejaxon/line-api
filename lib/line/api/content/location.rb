require_relative 'base'

module Line
  module Api
    module Content
      # https://developers.line.me/businessconnect/api-reference#sending_message_location
      class Location < Base
        CONTENT_TYPE = 7
        attr_accessor :title, :latitude, :longitude, :address

        def to_json
          super.merge(
              text: title,
              location: {
                  title: title,
                  latitude: latitude,
                  longitude: longitude,
              })
        end
      end
    end
  end
end
