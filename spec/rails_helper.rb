# This file is copied to spec/ when you run "rails generate rspec:install"
require "securerandom"
ENV["RAILS_ENV"] ||= "test"
ENV["RAILS_SECRET_KEY_BASE"] ||= SecureRandom.hex

require File.expand_path("../../config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "simplecov"
SimpleCov.start "rails"

require "rspec/rails"
require "spec_helper"
require "rspec/autorun"
require "webmock/rspec"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
  #c.allow_http_connections_when_no_cassette = true
  # Get really verbose output for debugging VCR by uncommenting the following line
  c.debug_logger = STDOUT
  # Uncomment the following line when recording new HTTP interactions
  # c.default_cassette_options = { record: :new_episodes }
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include GistHelper
  config.include DeploymentStatusHelper
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

Heaven.testing = true
