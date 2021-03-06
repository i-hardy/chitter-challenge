ENV["RACK_ENV"] = "test"

require File.join(File.dirname(__FILE__), '..', 'app/app.rb')

require 'database_cleaner'
require 'capybara'
require 'capybara/rspec'
require 'mail'
require 'orderly'
require 'simplecov'
require 'simplecov-console'
require_relative 'helpers/session'
require_relative 'helpers/peeping'

Capybara.app = Chitter

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::Console,
  # Want a nice code coverage website? Uncomment this next line!
  # SimpleCov::Formatter::HTMLFormatter
])
SimpleCov.start

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include SessionHelpers

  config.include PeepingHelpers

  config.include Mail::Matchers

  config.after(:suite) do
    puts
    puts "\e[33mHave you considered running rubocop? It will help you improve your code!\e[0m"
    puts "\e[33mTry it now! Just run: rubocop\e[0m"
  end
end

Mail.defaults do
  delivery_method :test
end
