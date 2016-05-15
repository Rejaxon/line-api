module Line
  module Api
    module Content
      class Base
        attr_accessor :to_type

        def initialize(attributes = {})
          attributes.each { |attr, value| self.public_send("#{attr}=", value) }
          self.to_type ||= 1
        end

        def to_json
          {
              contentType: self.class::CONTENT_TYPE,
              toType: to_type
          }
        end
      end
    end
  end
end
