require 'simplesol'
require 'rspec'
require 'vcr'

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
  #c.allow_http_connections_when_no_cassette = true
end
