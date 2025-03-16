require 'spec_helper'
require 'factory_bot_rails'
require 'database_cleaner/active_record'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

RSpec.configure do |config|
  # Add FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Helper method for controller specs
  config.include Module.new {
    def login_as(user)
      session[:user_id] = user.id
    end
  }

  # Add these lines to include request spec helpers
  config.include Rails.application.routes.url_helpers
  config.include RSpec::Rails::RequestExampleGroup, type: :request

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end 