require "dotenv"

# Fix for rake tasks loading in development
#
# Dotenv loads environment variables when the Rails application is initialized.
# When running `rake`, the Rails application is initialized in development.
# Rails includes some hacks to set `RAILS_ENV=test` when running `rake test`,
# but rspec does not include the same hacks.
#
# See https://github.com/bkeepers/dotenv/issues/219
if defined?(Rake.application)
  task_regular_expression = /^(default$|parallel:spec|spec(:|$))/
  if Rake.application.top_level_tasks.grep(task_regular_expression).any?
    environment = Rake.application.options.show_tasks ? "development" : "test"
    Rails.env = ENV["RAILS_ENV"] ||= environment
  end
end

DotenvVault.instrumenter = ActiveSupport::Notifications

# Watch all loaded env files with Spring
begin
  require "spring/commands"
  ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename if Rails.application
  end
rescue LoadError, ArgumentError
  # Spring is not available
end

module DotenvVault
  class Railtie < Rails::Railtie
    def load
      Dotenv.load(*dotenv_files)
    end

    def overload
      Dotenv.overload(*dotenv_files)
    end

    def root
      Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
    end

    def self.load
      instance.load
    end

    private

    def dotenv_files
      [
        root.join(".env.#{Rails.env}.local"),
        (root.join(".env.local") unless Rails.env.test?),
        root.join(".env.#{Rails.env}"),
        root.join(".env")
      ].compact
    end

    config.before_configuration { load }
  end
end
