require 'helper'

describe Simplesol do
  it 'should be configurable' do
    settings = { :login => 'login', :api_key => 'key', :api_server => 'server.ru' }
    Simplesol.configure do |c|
      c.login = settings[:login]
      c.api_key = settings[:api_key]
      c.api_server = settings[:api_server]
    end

    settings.each do |k, v|
      Simplesol.send(k).should == v
    end
  end

  context 'in general' do
    before :all do
      Simplesol.reset
      Simplesol.configure do |c|
        c.login = '98864536'
        c.api_key = 'RWffmNXb'
      end
    end

    it 'can fetch balance' do
      client = Simplesol::Client.new
      p client.connection.post('/user/balance').body
    end
  end
end
