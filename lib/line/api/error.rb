module Line
  module Api
    module Error
      class Communication < StandardError; end
      class RequestParameter < Communication; end

    end
  end
end
