# If you use gems that require environment variables to be set before they are
# loaded, then list `dotenv-vault-rails` in the `Gemfile` before those other gems and
# require `dotenv-vault/rails-now`.
#
#     gem "dotenv-vault-rails", require: "dotenv-vault/rails-now"
#     gem "gem-that-requires-env-variables"
#

require "dotenv-vault/rails"
DotenvVault::Railtie.load

