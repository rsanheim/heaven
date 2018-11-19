require "heaven/provider/capistrano"

module Heaven
  # Top-level module for providers.
  module Provider
    # A capistrano provider that installs gems.
    class BundlerCapistranoGit < Capistrano
      def initialize(guid, payload)
        super
        @name = "bundler_capistrano_git"
      end

      def cap_path
        gem_executable_path("cap")
      end

      def execute
        return execute_and_log(["/usr/bin/true"]) if Rails.env.test?

        unless File.exist?(checkout_directory)
          log "Cloning #{repository_url} into #{checkout_directory}"
          execute_and_log(["git", "clone", clone_url, checkout_directory])
        end

        Dir.chdir(checkout_directory) do
          log "Fetching the latest code"
          execute_and_log(%w{git fetch})
          execute_and_log(["git", "reset", "--hard", sha])

          File.write("deployment.json", deployment_data.to_json)

          Bundler.with_clean_env do
            if turnkey?
              turnkey = provision_turnkey
              ENV.store("TURNKEY_INSTANCE", turnkey[:turnkey_id])
            end

            if bundler_private_source.present? && bundler_private_credentials.present?
              bundler_config_string = ["bundle", "config", bundler_private_source, bundler_private_credentials]
              log "Adding bundler config"
              execute_and_log(bundler_config_string)
            end

            bundler_string = ["bundle", "install", "--without", ignored_groups.join(" ")]
            log "Executing bundler: #{bundler_string.join(" ")}"
            execute_and_log(bundler_string)
            deploy_string = ["script/deploy", environment]
            log "Executing capistrano: #{deploy_string.join(" ")}"
            execute_and_log(deploy_string, "BRANCH" => ref)
          end
        end
      end

      private

      def ignored_groups
        bundle_definition.groups - [:heaven, :deployment]
      end

      def bundle_definition
        gemfile_path = File.expand_path("Gemfile", checkout_directory)
        lockfile_path = File.expand_path("Gemfile.lock", checkout_directory)
        Bundler::Definition.build(gemfile_path, lockfile_path, nil)
      end

      def bundler_private_source
        ENV["BUNDLER_PRIVATE_SOURCE"]
      end

      def bundler_private_credentials
        ENV["BUNDLER_PRIVATE_CREDENTIALS"]
      end
    end
  end
end
