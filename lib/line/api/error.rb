module Line
  module Api
    module Error
      class Communication < StandardError; end
      class RequestParameter < Communication; end
      class InvalidRequestToken < RequestParameter; end

    end
  end
end
