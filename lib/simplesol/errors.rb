module Simplesol
  class NotConfiguredError < Exception
    def initialize
      @message = 'You have not provided Simplesol api settings: login or api_key'
    end
  end

  class Error < Exception
    attr_reader :code

    def initialize(response)
      @code = response.error
      @message = response.message
    end

    def self.parse(response)
      if response.error
        Simplesol::ERRORS[response.error].new response
      else
        Exception.new('error cannot be parsed')
      end
    end
  end

  class InvalidUserError < Error
  end

  class InvalidSignatureError < Error
  end

  class InvalidApiComponentError < Error
  end

  class InvalidApiComponentMethodError < Error
  end

  class InvalidRecipientsError < Error
  end

  class MessageIsEmptyError < Error
  end

  class SenderIsEmptyError < Error
  end

  class NotEnoughMoneyError < Error
  end

  class InvalidMessageIdError < Error
  end

  ERRORS = {
    1 => InvalidUserError,
    2 => InvalidSignatureError,
    4 => InvalidApiComponentError,
    5 => InvalidApiComponentMethodError,
    6 => InvalidRecipientsError,
    7 => MessageIsEmptyError,
    8 => SenderIsEmptyError,
    9 => NotEnoughMoneyError,
    10 => InvalidMessageIdError
  }
end
