require 'fastlane/plugin/dotenv_vault/version'
require 'fastlane/plugin/dotenv_vault/logger'

module Fastlane
  module DotenvVault
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::DotenvVault.all_classes.each do |current|
  require current
end

# Monkeypatch DotenvVault.logger
module DotenvVault
  class << self
    def logger
      @logger ||= Fastlane::DotenvVault::Logger.new
    end
  end
end
