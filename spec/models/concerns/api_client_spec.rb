require "rails_helper"

describe ApiClient do
  class ApiClientTester
    include ApiClient
  end

  let(:tester) { ApiClientTester.new }

  describe "#api" do
    it "#api uses #github_token to auth requests" do
      ENV["GITHUB_TOKEN"] = "secret"
      stub_request(:get, "https://api.github.com/user")
        .with(:headers => octokit_request_headers)
        .to_return(:status => 200, :body => "atmos")
      expect(tester.api.user).to eql("atmos")
    end
  end

  describe "#oauth_client_api" do
    it "#oauth_client_api uses #github_client_id and #github_client_secret" do
      ENV["GITHUB_CLIENT_ID"]     = "id"
      ENV["GITHUB_CLIENT_SECRET"] = "secret"
     
      # TODO: Investigate this,  I think something updated with the Octokit::Client so this
      # isn't really testing anything anymore
      # stub_request(:get, "https://api.github.com/meta?client_id=id&client_secret=secret")
      stub_request(:get, "https://api.github.com/meta")
        .with(:headers => octokit_request_headers)
        .to_return(:status => 200, :body => "ok")

      expect(tester.oauth_client_api.meta).to eql("ok")
    end
  end

  def octokit_request_headers
    { "Accept"          => "application/vnd.github.v3+json",
      "User-Agent"      => "Octokit Ruby Gem #{Octokit::VERSION}",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3" }
  end
end
