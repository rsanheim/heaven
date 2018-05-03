require "resque/tasks"

namespace :resque do
  task :setup => [:environment] do
    Resque.before_fork do
      ActiveRecord::Base.establish_connection

      logger = Logger.new(STDOUT)
      logger.formatter = ::Logger::Formatter.new

      Resque.logger = ActiveSupport::TaggedLogging.new(logger)
      Resque.logger.level = Logger::INFO
      Resque.logger.info "event=resque_logger_initialized"
    end
  end
end
