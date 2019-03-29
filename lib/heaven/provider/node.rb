 module Heaven
  module Provider
    class Node < DefaultProvider
      def initialize(guid, payload)
        super
        @name = "node"
      end

      def execute
        return execute_and_log(["/usr/bin/true"]) if Rails.env.test?

        unless File.exist?(checkout_directory)
          log "Cloning #{repository_url} into #{checkout_directory}"
          execute_and_log(["git", "clone", clone_url, checkout_directory])
        end

        Dir.chdir(checkout_directory) do
          log "Fetching the latest code"
          execute_and_log(["git", "reset", "--hard"])
          execute_and_log(%w(git checkout master))
          execute_and_log(%w{git fetch})
          execute_and_log(["git", "checkout", ref])
          execute_and_log(["git", "reset", "--hard", sha])

          File.write("deployment.json", deployment_data.to_json)

          yarn_install_string = ["yarn", "install", "--ignore-optional", "--non-interactive"]
          log "Attempting yarn install..."
          execute_and_log(yarn_install_string)

          deploy_string = ["script/deploy", environment]
          log "Executing deploy: #{deploy_string}"
          execute_and_log(deploy_string)
        end
      end
    end
  end
 end