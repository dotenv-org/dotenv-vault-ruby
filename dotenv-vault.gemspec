require_relative 'lib/dotenv_vault/version'

Gem::Specification.new "dotenv-vault" do |spec|
  spec.name          = "dotenv-vault"
  spec.version       = DotenvVault::VERSION
  spec.authors       = ["motdotla"]
  spec.email         = ["mot@mot.la"]

  spec.summary       = %q{dotenv-vault}
  spec.description   = %q{dotenv-vault}
  spec.homepage      = "https://github.com/dotenv-org/dotenv-vault-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dotenv-org/dotenv-vault-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/dotenv-org/dotenv-vault-ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

	spec.add_dependency "dotenv"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "standard"
end
