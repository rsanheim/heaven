require "spec_helper"

describe "Heaven::Notifier::Default" do
  context "chat_user" do
    it "returns user from notify data from payload" do
      data = {
        "deployment" => {
          "payload" => {
            "notify" => {
              "user_name" => "sarahconnor"
            }
          }
        }
      }
      notifier = Heaven::Notifier::Default.new(data)
      expect(notifier.chat_user).to eq("sarahconnor")
    end

    context "unkown chat user" do
      it "returns unknown chat user if payload is empty" do
        data = { "deployment" => {
          "payload" => {}
          }
        }
        notifier = Heaven::Notifier::Default.new(data)
        expect(notifier.chat_user).to eq("unknown")
      end

      it "does not generate a user_link if user is unknown or 'autodeploy'" do
        data = { "state" => "success",
          "deployment" => {
          "payload" => {}
          }
        }
        notifier = Heaven::Notifier::Default.new(data)
        expect(notifier.user_link).to eq("unknown")
      end
    end
  end

  it "does not deliver changes unless an environment opt-in is present" do
    notifier = Heaven::Notifier::Default.new("{}")

    expect(notifier.change_delivery_enabled?).to be_false

    ENV["HEAVEN_NOTIFIER_DISPLAY_COMMITS"] = "true"

    notifier = Heaven::Notifier::Default.new("{}")

    expect(notifier.change_delivery_enabled?).to be_true
  end
end
