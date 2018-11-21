require "heaven/provisioner/aws_lambda"

module Heaven
  module Provisioner
    PROVISIONERS ||= {
      "aws_lambda"  => AwsLambdaProvisioner
    }

    def self.from(data)
      klass = provisioner_class_for(data)
      klass.new(data) if klass
    end

    def self.provisioner_class_for(data)
      name     = provisioner_name_for(data)
      provisioner = PROVISIONERS[name]

      Rails.logger.error "No deployment system for #{name}" unless provisioner

      provisioner
    end

    def self.provisioner_name_for(data)
      return unless data &&
                    data.key?("deployment") &&
                    data["deployment"].key?("payload") &&
                    data["deployment"]["payload"].key?("turnkey")

      data["deployment"]["payload"]["turnkey"]["provisioner"]
    end
  end
end