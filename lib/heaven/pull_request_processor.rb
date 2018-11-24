module Heaven
  class PullRequestProcessor
    include ApiClient

    attr_accessor :guid, :data, :pull_request

    def initialize(guid, payload)
      @guid = guid
      @data = data
      @pull_request = api.pull_request(data["base"]["repo"]["full_name"], data["number"])
    end

    def open?
      pull_request[:state] == "open"
    end

    def deployments_perform
      deployments = pull_request[:base][:repo].rels[:deployments].get.data
      deployments.each do |deployment|
        # Make sure this deployment is related to this PR
        if deployment[:payload][:pull_request] && deployment[:payload][:pull_request][:id] == pull_request[:id]
          deployment_perform(deployment)
        end
      end
    end

    def deployment_perform(deployment)
      provisioner = Heaven::Provisioner.from(deployment)
      if provisioner
        unless open?
          provisioner.teardown!
        end
      end
    end

    def run!
      deployments_perform
    end
  end
end