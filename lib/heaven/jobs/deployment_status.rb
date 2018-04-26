module Heaven
  module Jobs
    # A deployment status handler
    class DeploymentStatus
      @queue = :deployment_statuses

      def self.perform(payload)
        Rails.logger.info "class=#{name} event=perform"
        notifier = Heaven::Notifier.for(payload)
        Rails.logger.info "class=#{name} event=perform notifier=#{notifier}"
        notifier.post! if notifier
      rescue => e
        Rails.logger.error "class=#{name} error=#{e} message=#{e.backtrace}"
      end
    end
  end
end
