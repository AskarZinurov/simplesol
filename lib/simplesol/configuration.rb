require 'digest/md5'

module Simplesol
  module Configuration
    VALID_OPTIONS_KEYS = [:login, :api_key, :debug, :api_server]

    DEFAULT_LOGIN    = nil
    DEFAULT_API_KEY = nil
    DEFAULT_DEBUG    = true
    DEFAULT_API_SERVER = 'api.sms.simplesol.ru'

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
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
