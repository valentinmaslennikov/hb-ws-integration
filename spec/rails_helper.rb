# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'webmock/rspec'

# Support libs
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

WebMock.disable!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include JsonHelpers,   type: :controller

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.file_fixture_path = 'spec/fixtures'

  config.before :each do
    ENV['CHAIN_HOST'] = rand.to_s
  end

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end
end
