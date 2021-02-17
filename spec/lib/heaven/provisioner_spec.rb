require "rails_helper"

describe Heaven::Provisioner do
  include FixtureHelper

  ENV["AWS_REGION"] = "us-west-2"

  describe ".from" do
    it "returns the correct provisioner based on deployment payload" do 
      data = decoded_fixture_data("deployment_turnkey")
      data["deployment"]["payload"]["turnkey"]["provisioner"] = "aws_lambda"

      provisioner = Heaven::Provisioner.from(data)

      expect(provisioner).to be_a(Heaven::Provisioner::AwsLambdaProvisioner)

      provisioner = Heaven::Provisioner.from({})

      expect(provisioner).to be_nil
    end
  end
end
