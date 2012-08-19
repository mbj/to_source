# encoding: utf-8

require 'rspec'

# require spec support files and shared behavior
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each { |f| require f }

require 'to_source'

RSpec.configure do |config|
end
