# Simplesol
Client gem for sms sending through http://simplesol.ru/.

## Installation

Add this line to your application's Gemfile:

    gem 'simplesol'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simplesol

## Usage
Configure

Instantiate Client class with some config:

```ruby
  @client = Simplesol::Client.new do |c|
    c.login    = '<your username>'
    c.api_key  = '<your api key>'
  end
```
or configure client later:
```ruby
  @client = Simplesol::Client.new
  @client.configure do |c|
    c.login    = '<your username>'
    c.api_key  = '<your api key>'
  end
```
or reset clients settings to defaults via:
```ruby
  @client.reset
```
Available commands
 
  - Sending message:

    ```ruby
      @client.send_message(['mobile1', 'mobile2'], 'Привет, как дела', { :sender => 'santa' })
    ```
  
  - Get sms message status:
    
    ```ruby
      @client.message_status(['message id'])
    ``` 

  - Get cost of message:
     
    ```ruby
      @client.message_price(['mobile1', 'mobile2'], 'Привет, как дела')
    ```

  - Check account balance:
     
    ```ruby
      @client.balance
    ```
For futher reading and testing please look at spec/simplesol_spec.rb

Tested with ruby-1.8.7-p370 and ruby-1.9.3-p327.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
