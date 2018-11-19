module Heaven
  module Jobs
    # A class for kicking off deployment processes
    class Deployment
      extend Resque::Plugins::LockTimeout

      @queue = :deployments
      @lock_timeout = Integer(ENV["DEPLOYMENT_TIMEOUT"] || "300")

      # Only allow one deployment per-environment at a time
      def self.redis_lock_key(guid, data)
        deployment_data = data["deployment"]
        if deployment_data["payload"] && deployment_data["payload"]["name"]
          name = deployment_data["payload"]["name"]
          return "#{name}-#{deployment_data["environment"]}-deployment"
        end
        guid
      end

      def self.identifier(guid, data)
        redis_lock_key(guid, data)
      end

      attr_accessor :guid, :data

      def initialize(guid, data)
        @guid = guid
        @data = data
      end

      def self.perform(guid, data)
        # This will provision a new environment if specified
        provisioner = Heaven::Provisioner.from(guid, data)
        provisioner.execute! if provisioner

        # Run code deployment
        provider = Heaven::Provider.from(guid, data)
        provider.run! if provider
      end
    end
  end
end
