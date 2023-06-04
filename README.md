# dotenv-vault [![Gem Version](https://badge.fury.io/rb/dotenv-vault.svg)](https://badge.fury.io/rb/dotenv-vault)

<img src="https://raw.githubusercontent.com/motdotla/dotenv/master/dotenv.svg" alt="dotenv-vault" align="right" width="200" />

Extends the proven & trusted foundation of [dotenv](https://github.com/bkeepers/dotenv), with `.env.vault` file support.

The extended standard lets you load encrypted secrets from your `.env.vault` file in production (and other) environments. Brought to you by the same people that pioneered [dotenv-nodejs](https://github.com/motdotla/dotenv).

* [🌱 Install](#-install)
* [🏗️ Usage (.env)](#%EF%B8%8F-usage)
* [🚀 Deploying (.env.vault) 🆕](#-deploying)
* [🌴 Multiple Environments](#-manage-multiple-environments)
* [❓ FAQ](#-faq)
* [⏱️ Changelog](./CHANGELOG.md)

## 🌱 Install

### Rails

Add this line to the top of your application's Gemfile:

```ruby
gem "dotenv-vault-rails"
```

And then execute:

```shell
$ bundle
```

### Sinatra or Plain ol' Ruby

Install the gem:

```shell
$ gem install dotenv-vault
```

As early as possible in your application bootstrap process, load `.env`:

```ruby
require "dotenv-vault/load"

# or
require "dotenv-vault"
DotenvVault.load
```

## 🏗️ Usage

Development usage works just like [dotenv](https://github.com/bkeepers/dotenv).

Add your application configuration to your `.env` file in the root of your project:

```shell
S3_BUCKET=YOURS3BUCKET
SECRET_KEY=YOURSECRETKEYGOESHERE
```

When your application loads, these variables will be available in `ENV`:

```ruby
config.fog_directory  = ENV["S3_BUCKET"]
```

## 🚀 Deploying

Encrypt your `.env.vault` file.

```bash
$ npx dotenv-vault build
```

Fetch your production `DOTENV_KEY`.

```bash
$ npx dotenv-vault keys production
```

Set `DOTENV_KEY` on your server.

```bash
# heroku example
heroku config:set DOTENV_KEY=dotenv://:key_1234…@dotenv.org/vault/.env.vault?environment=production
```

That's it! On deploy, your `.env.vault` file will be decrypted and its secrets injected as environment variables – just in time.

*ℹ️ A note from [Mot](https://github.com/motdotla): Until recently, we did not have an opinion on how and where to store your secrets in production. We now strongly recommend generating a `.env.vault` file. It's the best way to prevent your secrets from being scattered across multiple servers and cloud providers – protecting you from breaches like the [CircleCI breach](https://techcrunch.com/2023/01/05/circleci-breach/). Also it unlocks interoperability WITHOUT native third-party integrations. Third-party integrations are [increasingly risky](https://coderpad.io/blog/development/heroku-github-breach/) to our industry. They may be the 'du jour' of today, but we imagine a better future.*

<a href="https://github.com/dotenv-org/dotenv-vault#dotenv-vault-">Learn more at dotenv-vault: Deploying</a>

## 🌴 Manage Multiple Environments

Edit your production environment variables.

```bash
$ npx dotenv-vault open production
```

Regenerate your `.env.vault` file.

```bash
$ npx dotenv-vault build
```

*ℹ️  🔐 Vault Managed vs 💻 Locally Managed: The above example, for brevity's sake, used the 🔐 Vault Managed solution to manage your `.env.vault` file. You can instead use the 💻 Locally Managed solution. [Read more here](https://github.com/dotenv-org/dotenv-vault#how-do-i-use--locally-managed-dotenv-vault). Our vision is that other platforms and orchestration tools adopt the `.env.vault` standard as they did the `.env` standard. We don't expect to be the only ones providing tooling to manage and generate `.env.vault` files.*

<a href="https://github.com/dotenv-org/dotenv-vault#-manage-multiple-environments">Learn more at dotenv-vault: Manage Multiple Environments</a>

## ❓ FAQ

#### What happens if `DOTENV_KEY` is not set?

Dotenv Vault gracefully falls back to [dotenv](https://github.com/bkeepers/dotenv) when `DOTENV_KEY` is not set. This is the default for development so that you can focus on editing your `.env` file and save the `build` command until you are ready to deploy those environment variables changes.

#### Should I commit my `.env` file?

No. We **strongly** recommend against committing your `.env` file to version control. It should only include environment-specific values such as database passwords or API keys. Your production database should have a different password than your development database.

#### Should I commit my `.env.vault` file?

Yes. It is safe and recommended to do so. It contains your encrypted envs, and your vault identifier.

#### Can I share the `DOTENV_KEY`?

No. It is the key that unlocks your encrypted environment variables. Be very careful who you share this key with. Do not let it leak.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog

See [CHANGELOG.md](CHANGELOG.md)

## License

MIT
