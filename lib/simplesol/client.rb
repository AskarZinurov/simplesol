require 'hashie'
require 'digest/md5'
require 'digest/sha1'

module Simplesol
  class Client
    include Configuration

    attr_reader :connection

    def initialize
      reset
      configure { yield(self) } if block_given?

      @connection = Faraday::Connection.new(:url => api_server) do |c|
        c.request  :url_encoded
        c.response :rashify
        c.response :dates
        c.response :json

        c.adapter Faraday.default_adapter
      end
    end

    def balance
      call('user/balance')
    end

    # Message Functions

    # param:recipients is array of mobile phones strings
    # param:message is text of sms message
    # options: {:sender => 'Sender', :test => 0}, :test can be 0, 1
    def send_message(recipients, message, options = {})
      call('message/send', { :recipients => recipients.join(','), :message => message }.merge(options))
    end

    # param:messages_id array of messages ids
    def message_status(messages_id)
      call('message/status', { :messages_id => messages_id.join(',') })
    end

    # param:recipients is array of mobile phones strings
    # param:message is text of sms message
    def message_price(recipients, message)
      call('message/price', { :recipients => recipients.join(','), :message => message })
    end

    private

    def call(url, params = {})
      raise Simplesol::NotConfiguredError.new unless configured?
      signed_params = params.merge(calculate_sign(params))
      signed_params.merge!(:user => login)
      response = connection.post(url, signed_params).body
      raise Simplesol::Error.parse(response) if response.status == 'error'
      response
    end

    def calculate_sign(params)
      str = [login]
      params.keys.map(&:to_s).sort.each {|k| str << params[k.to_sym] }
      str << api_key
      { :sign => Digest::MD5.hexdigest(Digest::SHA1.hexdigest(str.compact.join(''))) }
    end
  end
end
