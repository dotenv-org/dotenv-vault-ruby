require "bundler/gem_tasks"

namespace "dotenv-vault" do
  Bundler::GemHelper.install_tasks name: "dotenv-vault"
end

class DotenvVaultRailsGemHelper < Bundler::GemHelper
  def guard_already_tagged
    # noop
  end

  def tag_version
    # noop
  end
end

namespace "dotenv-vault-rails" do
  DotenvRailsGemHelper.install_tasks name: "dotenv-vault-rails"
end

task build: ["dotenv-vault:build", "dotenv-vault-rails:build"]
task install: ["dotenv-vault:install", "dotenv-vault-rails:install"]
task release: ["dotenv-vault:release", "dotenv-vault-rails:release"]

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

task default: :spec
