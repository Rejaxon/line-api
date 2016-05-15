require "line/api/version"
require "line/api/client"
require "line/api/util"

module Line
  module Api

    def self.client(options={})
      Line::Api::Client.new(options)
    end

  end
end
