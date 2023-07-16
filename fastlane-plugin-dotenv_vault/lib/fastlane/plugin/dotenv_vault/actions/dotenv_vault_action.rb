require 'fastlane/action'
require 'fastlane_core/configuration/config_item'
require 'dotenv-vault'
require_relative '../helper/dotenv_vault_helper'

module Fastlane
  module Actions
    class DotenvVaultAction < Action
      def self.run(params)
        params.values

        if defined?(::DotenvVault)
          ::DotenvVault.load(params[:vault_path])
        end
      end

      def self.description
        "Decrypt .env.vault file."
      end

      def self.authors
        ["mileszim", "motdotla"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Extends the proven & trusted foundation of dotenv, with a .env.vault file."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :vault_path,
                                  env_name: "DOTENV_VAULT_PATH",
                               description: "Path to .env.vault file (default is ./.env.vault)",
                             default_value: ".env.vault",
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
