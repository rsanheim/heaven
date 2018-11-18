require "heaven/provider/aws_lambda"

module Heaven
  module Provisioner
    PROVISIONERS ||= {
      "aws_lambda"  => AwsLambdaProvisioner
    }

    def self.from(guid, data)
      klass = provisioner_class_for(data)
      klass.new(guid, data) if klass
    end

    def self.provisioner_class_for(data)
      name     = provisioner_name_for(data)
      provider = PROVISIONERS[name]

      Rails.logger.info "No deployment system for #{name}" unless provider

      provider
    end

    def self.provisioner_name_for(data)
      return unless data &&
                    data.key?("deployment") &&
                    data["deployment"].key?("payload") &&
                    data["deployment"]["payload"].key("turnkey")

      data["deployment"]["payload"]["turnkey"]["provisioner"]
    end
  end
end