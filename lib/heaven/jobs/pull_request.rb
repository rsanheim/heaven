module Heaven
  module Jobs
    class PullRequest
      extend Resque::Plugins::LockTimeout
      include ApiClient

      @queue = :pull_requests
      @lock_timeout = Integer(ENV["DEPLOYMENT_TIMEOUT"] || "300")

      attr_accessor :guid, :data, :id

      def initialize(guid, data)
        @guid = guid
        # Get the PR as a Sawyer type to take full advantage of hypermedia
        @data = api.pull_request(data["base"]["repo"]["full_name"], data["number"])
        @id = data[:id]
      end

      def open?
        data[:state] == "open"
      end

      def deployments_perform
        deployments = data[:base][:repo].rels[:deployments].get.data
        deployments.each do |deployment|
          # Make sure this deployment is related to this PR
          if deployment[:payload][:pull_request] && deployment[:payload][:pull_request][:id] == id
            deployment_perform(deployment)
          end
        end
      end

      def deployment_perform(deployment)
        provisioner = Heaven::Provisioner.from(data)
        if provisioner
          unless open?
            provisioner.teardown!
        end
      end

      def self.perform(guid, data)
        deployments_perform
      end
    end
  end
end