require "line/api/version"
require "line/api/client"
require "line/api/util"
Dir[File.dirname(__FILE__) + '/api/content/*.rb'].each {|f| require f }

module Line
  module Api

    def self.client(options={})
      Line::Api::Client.new(options)
    end

  end
end
