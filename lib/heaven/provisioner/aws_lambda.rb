module Heaven
  module Provisioner
    class AwsLambdaProvisioner
    
      attr_accessor :aws_region, :guid, :data, :client, :response

      def initialize(guid, data)
        @guid       = guid
        @data       = data
        @aws_region = ENV.fetch('AWS_REGION')
        @client     = Aws::Lambda::Client.new(region: "#{aws_region}")
      end

      def execute

        function_name = data["deployment"]["payload"]["turnkey"]["deploy_function"]
        pull_request = data["deployment"]["payload"]["pull_request"]

        response = client.invoke(
          function_name: function_name,
          payload: { pull_request: pull_request }.to_json
        )
        
        # expects a payload with the following:
        # : turnkey_id: an id for the provisioned environment, which can be passed to a provider
        # : turnkey_url: URL where the provisioned environment can be accessed
        @response = JSON.parse(response.payload.string, symbolize_names: true)

        raise Errors::FunctionInvocationError, "#{response.status_code}: #{response.function_error}"
      end
    end
  end
end