lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/dotenv_vault/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-dotenv_vault'
  spec.version       = Fastlane::DotenvVault::VERSION
  spec.authors       = ['mileszim', 'motdotla']
  spec.email         = ['miles@zim.dev', 'mot@mot.la']

  spec.summary       = 'Decrypt .env.vault file.'
  spec.homepage      = "https://github.com/dotenv-org/dotenv-vault-ruby"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dotenv-org/dotenv-vault-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/dotenv-org/dotenv-vault-ruby"

  spec.metadata["rubygems_mfa_required"] = 'true'

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency('dotenv-vault', '~> 0.10.0')

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('fastlane', '>= 2.211.0')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rubocop', '1.12.1')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-rake')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('rubocop-rspec')
  spec.add_development_dependency('simplecov')
end
