require "heaven/comparison/linked"

module Heaven
  module Notifier
    # A notifier for Slack
    class Slack < Notifier::Default
      def deliver(message)
        output_message   = ""
        filtered_message = slack_formatted(message)

        Rails.logger.info "class=#{self.class.name} slack: #{filtered_message}"
        Rails.logger.info "message: #{message}"

        output_message << "##{deployment_number} - #{repo_name} / #{ref} / #{environment}"

        options = {
          :username    => slack_bot_name,
          :icon_url    => slack_bot_icon,
          :attachments => [{
            :text    => filtered_message,
            :color   => green? ? "good" : "danger",
            :pretext => pending? ? output_message : " "
          }]
        }
        options.merge!(channel: "#{chat_room}") if chat_room
        slack_account.ping "", options
      end

      def default_message
        message = output_link("##{deployment_number}")
        message << " : #{user_link}"
        case task
        when "deploy"
          message << deploy_message
        when "refresh_database"
          message << refresh_database_message
        else
          puts "Unhandled deployment state, #{state}"
        end
      end

      def deploy_message
        message = ""
        case state
        when "success"
          message << "'s #{environment} deployment of #{repository_link} is done! "
        when "in_progress"
          message << "'s #{environment} provisioning of #{repository_link} is ready " 
          message << "and will be [available here](#{environment_url}) once deploy is complete "
        when "failure"
          message << "'s #{environment} deployment of #{repository_link} failed. "
        when "error"
          message << "'s #{environment} deployment of #{repository_link} has errors. #{ascii_face} "
          message << description unless description =~ /Deploying from Heaven/
        when "pending"
          message << " is deploying #{repository_link("/tree/#{ref}")} to #{environment} #{compare_link}"
        else
          puts "Unhandled deployment state, #{state}"
        end
      end

      def refresh_database_message
        message = ""
        case state
        when "success"
          message << "'s refresh of the #{repository_link} database in #{environment} is complete! :success:"
        when "in_progress"
          message << "'s refresh of the #{repository_link} database in #{environment} is in progress (I really don't know how I'm delivering _this_ message)"
        when "failure"
          message << "'s refresh of the #{repository_link} database in #{environment} has failed! #{ascii_face}"
        when "error"
          message << "'s refresh of the #{repository_link} database in #{environment} has errors. #{ascii_face}"
        when "pending"
          message << " is refreshing the #{repository_link} database in #{environment}"
        else
          puts "Unhandled database refresh state, #{state}"
        end
      end

      def slack_formatted(message)
        ::Slack::Notifier::LinkFormatter.format(message)
      end

      def changes
        Heaven::Comparison::Linked.new(comparison, name_with_owner).changes(commit_change_limit)
      end

      def compare_link
        "([compare](#{comparison["html_url"]}))" if last_known_revision
      end

      def slack_webhook_url
        ENV["SLACK_WEBHOOK_URL"]
      end

      def slack_bot_name
        ENV["SLACK_BOT_NAME"] || "hubot"
      end

      def slack_bot_icon
        ENV["SLACK_BOT_ICON"] || "https://octodex.github.com/images/labtocat.png"
      end

      def slack_account
        @slack_account ||= ::Slack::Notifier.new(slack_webhook_url)
      end
    end
  end
end
