require "spec_helper"

describe Deployment::Credentials do
  it "correctly sets up the environment" do
    root = "#{Dir.pwd}/tmp"
    credentials = Deployment::Credentials.new(root)

    expect { credentials.setup! }.to_not raise_error
    expect(File.exist?("#{root}/.netrc")).to eq(true)
    expect(File.exist?("#{root}/.ssh/config")).to eq(true)
    expect(File.exist?("#{root}/.ssh/id_rsa")).to eq(true)
  end
end
