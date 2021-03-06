require 'digest/md5'

module Simplesol
  module Configuration
    VALID_OPTIONS_KEYS = [:login, :api_key, :debug, :api_server]

    DEFAULT_LOGIN      = nil
    DEFAULT_API_KEY    = nil
    DEFAULT_DEBUG      = true
    DEFAULT_API_SERVER = 'http://api.gosmsinfo.ru/api'

    attr_accessor *VALID_OPTIONS_KEYS

    def configured?
      status = login && api_key && api_server
      !(status.nil? || status.empty?)
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def reset
      VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", Simplesol::Configuration.const_get("default_#{key}".upcase))
      end
    end
  end
end
