require 'hashie'

module Simplesol
  class Client
    attr_reader :connection

    def initialize
      @connection = Faraday::Connection.new(:url => Simplesol.api_server) do |c|
        c.request  :url_encoded
        c.response :rashify
        c.response :dates
        c.response :json

        c.adapter Faraday.default_adapter
      end
    end
  end
end
