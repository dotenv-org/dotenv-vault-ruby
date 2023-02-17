require 'dotenv-vault'

module Fastlane
  module Helper
    class DotenvVaultHelper
      def self.load(*filenames)
        ::DotenvVault.load(*filenames)
      end

      # same as `load`, but raises Errno::ENOENT if any files don't exist
      def self.load!(*filenames)
        ::DotenvVault.load!(*filenames)
      end

      # same as `load`, but will override existing values in `ENV`
      def self.overload(*filenames)
        ::DotenvVault.overload(*filenames)
      end

      # same as `overload`, but raises Errno:ENOENT if any files don't exist
      def self.overload!(*filenames)
        ::DotenvVault.overload!(*filenames)
      end

      # returns a hash of parsed key/value pairs but does not modify ENV
      def self.parse(*filenames)
        ::DotenvVault.parse(*filenames)
      end
    end
  end
end
