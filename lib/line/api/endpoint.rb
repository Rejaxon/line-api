Dir[File.dirname(__FILE__) + '/endpoint/*.rb'].each {|f| require f }

module Line
  module Api
    module Endpoint
      include AccessToken
      include Friend
    end
  end
end
