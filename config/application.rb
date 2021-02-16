require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Heaven
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    logger = Logger.new(STDOUT)
    logger.formatter = ::Logger::Formatter.new

    config.logger = ActiveSupport::TaggedLogging.new(logger)
    config.log_level = ENV["HEAVEN_LOG_LEVEL"] || :info

    config.serve_static_files = true
    config.action_dispatch.x_sendfile_header = nil

    config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end
