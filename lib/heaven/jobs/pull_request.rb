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
        @data = data
        @id = data[:id]
      end

      def open?
        data[:state] == "open"
      end

      def deployments_perform
        pull_request = api.pull_request(data["base"]["repo"]["full_name"], data["number"])
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
      end

      def self.perform(guid, data)
        self.deployments_perform
      end
    end
  end
end