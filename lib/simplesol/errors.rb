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
        Simplesol::ERRORS[response.error-1].new response
      else
        Exception.new('error cannot be parsed')
      end
    end
  end

  class InvalidUserError < Error
  end

  class InvalidSignatureError < Error
  end

  class EmptyMessageError < Error
  end

  class IncorrectRecipientsListError < Error
  end

  class NotEnoughMoneyError < Error
  end

  ERRORS = [InvalidUserError, InvalidSignatureError, EmptyMessageError,
    IncorrectRecipientsListError, NotEnoughMoneyError]
end
