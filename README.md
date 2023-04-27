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
gem 'dotenv-vault-rails'
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
require 'dotenv-vault/load'

# or
require 'dotenv-vault'
DotenvVault.load
```

## 🏗️ Usage

### `.env`

Basic usage works just like [dotenv](https://github.com/bkeepers/dotenv).

Add your application configuration to your `.env` file in the root of your project:

```shell
S3_BUCKET=YOURS3BUCKET
SECRET_KEY=YOURSECRETKEYGOESHERE
```

When your application loads, these variables will be available in `ENV`:

```ruby
config.fog_directory  = ENV['S3_BUCKET']
```

## 🚀 Deploying

### `.env.vault`

The `.env.vault` extends `.env`. It facilitates syncing your `.env` file across machines, team members, and environments.

Usage is similar to git. In the same directory as your `.env` file, run the command:

```shell
$ npx dotenv-vault new
```

Follow those instructions and then run:

```shell
$ npx dotenv-vault login
```

Then run push and pull:

```shell
$ npx dotenv-vault push
$ npx dotenv-vault pull
```

That's it!

You just synced your `.env` file. Commit your `.env.vault` file to code, and tell your teammates to run `npx dotenv-vault pull`.

[Learn more](https://www.dotenv.org/docs/tutorials/sync)

## 🌴 Manage Multiple Environments

Run the command:

```shell
$ npx dotenv-vault open production
```

It will open up an interface to manage your production environment variables.

[Learn more](https://www.dotenv.org/docs/tutorials/environments)

Build your encrypted `.env.vault`:

```shell
$ npx dotenv-vault build
```

Safely commit and push your changes:

```shell
$ git commit -am "Updated .env.vault"
$ git push
```

Obtain your `DOTENV_KEY`:

```shell
$ npx dotenv-vault keys
```

Set `DOTENV_KEY` on your infrastructure. For example, on Heroku:

```shell
$ heroku config:set DOTENV_KEY="dotenv://:key_1234@dotenv.org/vault/.env.vault?environment=production"
```

All set! When your app boots, it will recognize a `DOTENV_KEY` is set, decrypt the `.env.vault` file, and load the variables to `ENV`.

Made a change to your production envs? Run `npx dotenv-vault build`, commit that safely to code, and deploy. It's simple and safe like that.

[Learn more](https://www.dotenv.org/docs/tutorials/integrations)

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
