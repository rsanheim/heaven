module Heaven
  module Jobs
    class PullRequest
      extend Resque::Plugins::LockTimeout

      @queue = :pull_requests
      @lock_timeout = Integer(ENV["DEPLOYMENT_TIMEOUT"] || "300")

      attr_accessor :guid, :data

      def initialize(guid, data)
        @guid = guid
        @data = data
      end

      def self.perform(guid, data)
        pull_request_processor = Heaven::PullRequestProcessor.new(guid, data)
        pull_request_processor.run!
      end
    end
  end
end