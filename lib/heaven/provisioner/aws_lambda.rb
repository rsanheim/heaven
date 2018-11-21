module Heaven
  module Provisioner
    class AwsLambdaProvisioner

      module Errors
        class FunctionInvocationError < StandardError
        end
      end
    
      attr_accessor :aws_region, :data, :client, :response

      def initialize(data)
        @data       = data
        @aws_region = ENV.fetch('AWS_REGION')
        @client     = Aws::Lambda::Client.new(region: "#{aws_region}")
      end

      def execute!
        function_name = data["deployment"]["payload"]["turnkey"]["deploy_function"]
        pull_request = data["deployment"]["payload"]["pull_request"]

        response = client.invoke(
          function_name: function_name,
          payload: { pull_request: pull_request }.to_json
        )

        unless ((200..299) === response.status_code) && !response.key?("function_error")
          raise Errors::FunctionInvocationError, "#{response.status_code}: #{response.function_error}"
        end
        
        # expects a payload with the following:
        # : turnkey_id: an id for the provisioned environment, which can be passed to a provider
        # : turnkey_url: URL where the provisioned environment can be accessed
        @response = JSON.parse(response.payload.string, symbolize_names: true)
      end
    end
  end
end