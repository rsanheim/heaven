require "resque/tasks"

namespace :resque do
  task :setup => [:environment] do
    Resque.before_fork do
      ActiveRecord::Base.establish_connection

      Resque.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
      Resque.logger.level = Logger::INFO
      Resque.logger.info "event=resque_logger_initialized"
    end
  end
end
