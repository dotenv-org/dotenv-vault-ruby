require 'fastlane/action'
require 'dotenv-vault'
require_relative '../helper/dotenv_vault_helper'

module Fastlane
  module Actions
    class DotenvVaultAction < Action
      def self.run(_params)
        if defined?(::DotenvVault)
          ::DotenvVault.load
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
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "DOTENV_VAULT_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
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
