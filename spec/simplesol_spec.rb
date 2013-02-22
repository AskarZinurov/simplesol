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

  context 'in error scope' do
    use_vcr_cassette 'simplesol_errors'

    before :all do
      Simplesol.reset
      Simplesol.configure do |c|
        c.login = '555555'
        c.api_key = 'wrong'
      end
      @wrong_client = Simplesol::Client.new
    end

    it 'raise signature error' do
      expect { @wrong_client.balance }.to raise_error(Simplesol::InvalidSignatureError)
    end
  end

=begin
  context 'in general' do
    use_vcr_cassette 'simplesol'

    before :all do
      Simplesol.reset
      Simplesol.configure do |c|
        c.login = '<your login>'
        c.api_key = '<your code>'
      end
      @test_mobile_number = '' #'+79033144333'
      @client = Simplesol::Client.new
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
