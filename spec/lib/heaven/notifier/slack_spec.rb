require "rails_helper"

describe "Heaven::Notifier::Slack" do
  include FixtureHelper

  it "does not require a chat room" do
    Heaven.redis.set("atmos/my-robot-production-revision", "sha")

    data = decoded_fixture_data("deployment-success")
    data["deployment"]["payload"]["notify"].delete("room")

    notifier = Heaven::Notifier::Slack.new(data)
  end

  it "handles pending notifications" do
    Heaven.redis.set("atmos/my-robot-production-revision", "sha")

    data = decoded_fixture_data("deployment-pending")

    notifier = Heaven::Notifier::Slack.new(data)
    notifier.comparison = {
      "html_url" => "https://github.com/org/repo/compare/sha...sha"
    }

    result = [
      "[#123456](https://gist.github.com/fa77d9fb1fe41c3bb3a3ffb2c) ",
      ": atmos is deploying ",
      "[my-robot](https://github.com/atmos/my-robot/tree/break-up-notifiers) ",
      "to production ([compare](https://github.com/org/repo/compare/sha...sha))"
    ]
    
    expect(notifier.default_message).to eql result.join("")
  end

  it "handles successful deployment statuses" do
    data = decoded_fixture_data("deployment-success")

    notifier = Heaven::Notifier::Slack.new(data)

    result = [
      "[#11627](https://gist.github.com/fa77d9fb1fe41c3bb3a3ffb2c) ",
      ": atmos's production deployment of ",
      "[my-robot](https://github.com/atmos/my-robot) ",
      "is done! "
    ]
    expect(notifier.default_message).to eql result.join("")
  end

  it "handles failure deployment statuses" do
    data = decoded_fixture_data("deployment-failure")

    notifier = Heaven::Notifier::Slack.new(data)

    result = [
      "[#123456](https://gist.github.com/fa77d9fb1fe41c3bb3a3ffb2c) ",
      ": atmos's production deployment of ",
      "[my-robot](https://github.com/atmos/my-robot) ",
      "failed. "
    ]
    expect(notifier.default_message).to eql result.join("")
  end
end
