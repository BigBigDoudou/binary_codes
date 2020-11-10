# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'database_cleaner'
require 'rspec/rails'
require 'spec_helper'

# COVERAGE

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# GUARDS

abort('The Rails environment is running in production mode!') if Rails.env.production?

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# SHOULDA_MATCHERS CONFIGURATION

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# RSPEC CONFIGURATION

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Rails.application.routes.url_helpers, type: :controller

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
    I18n.locale = :en
  end

  config.around do |example|
    if example.metadata[:skip_database_cleaner]
      example.run
    else
      DatabaseCleaner.cleaning { example.run }
    end
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
