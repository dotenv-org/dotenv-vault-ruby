require 'fastlane_core/ui/ui'

# Monkeypatch DotenvVault to use fastlane_core ui
module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module DotenvVault
    class Logger
      def debug(message)
        UI.verbose(message)
      end

      def info(message)
        UI.message(message)
      end

      def warn(message)
        UI.important(message)
      end

      def error(message)
        UI.error(message)
      end

      def fatal(message)
        UI.error(message)
      end

      def unknown(message)
        UI.message(message)
      end

      def log(_level, message)
        UI.message(message)
      end

      def <<(message)
        UI.message(message)
      end

      def close
        # noop
      end

      def reopen
        # noop
      end

      def flush
        # noop
      end

      def level
        # noop
      end

      def level=(level)
        # noop
      end
    end
  end
end
