require 'helper'

describe Simplesol do
  it 'should be configurable' do
    settings = { :login => 'login', :api_key => 'key', :api_server => 'server.ru' }
    client = Simplesol::Client.new do |c|
      c.login = settings[:login]
      c.api_key = settings[:api_key]
      c.api_server = settings[:api_server]
    end

    settings.each do |k, v|
      client.send(k).should == v
    end
  end

  it 'should raise NotConfiguredError' do
    client = Simplesol::Client.new
    expect { client.balance }.to raise_error(Simplesol::NotConfiguredError)
  end

  it 'can be configured later' do
    client = Simplesol::Client.new
    client.configure do |c|
      c.api_key = 'some'
      c.login = 'settings'
    end
    client.should be_configured
  end

  it 'can reset settings to defaults' do
    client = Simplesol::Client.new do |c|
      c.login = 'sample login'
    end
    client.reset
    client.login.should == Simplesol::Configuration::DEFAULT_LOGIN
  end

  context 'in error scope' do
    use_vcr_cassette 'simplesol_errors'

    before :all do
      @wrong_client = Simplesol::Client.new do |c|
        c.login = '555555'
        c.api_key = 'wrong'
      end
    end

    it 'raise signature error' do
      expect { @wrong_client.balance }.to raise_error(Simplesol::InvalidSignatureError)
    end

    Simplesol::ERRORS.each do |code, error|
      it "should raise #{error} when code is #{code}" do
        response = double(:status => 'error', :error => code, :message => 'error message')
        @wrong_client.connection.stub(:post).and_return(double(:body => response))
        expect { @wrong_client.balance }.to raise_error(error)
      end
    end
  end

  # This context actually send requests to api and records them to vcr casette,
  # so you should provide your actual api login and api key to run them properly.
  # Btw this context does not change your balance - all sms sending runs in test mode.
=begin
  context 'in general' do
    use_vcr_cassette 'simplesol'

    before :all do
      @test_mobile_number = '<your mobile number>'
      @client = Simplesol::Client.new do |c|
        c.login = '<your login>'
        c.api_key = '<your api key>'
      end
    end

    it 'can fetch balance' do
      resp = @client.balance
      should_be_success resp
    end

    it 'can send test message' do
      resp = @client.send_message([@test_mobile_number], 'Привет, как дела?', { :sender => 'santa', :test => 1 })
      should_be_success resp
      %w(balance count messages_id parts price recipients).each do |m|
        resp.should respond_to(m)
      end
      resp.messages_id.should_not be_empty
    end

    it 'can fetch price' do
      resp = @client.message_price [@test_mobile_number], 'Привет, как дела?'
      %w(balance blocked price parts recipients).each do |m|
        resp.should respond_to(m)
      end
      should_be_success resp
    end

    it 'can get statuses' do
      resp = @client.message_status [1]
      %w(messages details).each do |m|
        resp.should respond_to(m)
      end
      should_be_success resp
    end
  end
=end

  def should_be_success(response)
    response.status.should == 'success'
  end
end
