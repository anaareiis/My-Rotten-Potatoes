require 'simplecov'
SimpleCov.start 'rails'

require 'cucumber/rails'
require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end
