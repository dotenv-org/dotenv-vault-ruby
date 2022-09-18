# dotenv-vault [![Gem Version](https://badge.fury.io/rb/dotenv-vault.svg)](https://badge.fury.io/rb/dotenv-vault)

<img src="https://raw.githubusercontent.com/motdotla/dotenv/master/dotenv.svg" alt="dotenv-vault" align="right" width="200" />

Dotenv Vault extends the proven & trusted foundation of [dotenv](https://github.com/bkeepers/dotenv), with a `.env.vault` file.

This new standard lets you sync your .env files – quickly & securely. Stop sharing them over insecure channels like Slack and email, and never lose an important .env file again.

## Installation

### Rails

Add this line to the top of your application's Gemfile:

```ruby
gem 'dotenv-vault-rails'
```

And then execute:

```shell
$ bundle
```

## Usage

### `.env`

Basic usage begins just like [dotenv](https://github.com/bkeepers/dotenv).

Add your application configuration to your `.env` file in the root of your project:

```shell
S3_BUCKET=YOURS3BUCKET
SECRET_KEY=YOURSECRETKEYGOESHERE
```

Whenever your application loads, these variables will be available in `ENV`:

```ruby
config.fog_directory  = ENV['S3_BUCKET']
```

### `.env.vault`

Usage is similar to git. In the same directory as your `.env` file, run the command:

```shell
npx dotenv-vault new
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

## Multiple Environments

Run the command:

```shell
$ npx dotenv-vault open production
```

It will open up an interface to manage your production environment variables.

..or if you prefer to manage them in your text editor, run the command:

```shell
$ npx dotenv-vault pull production
```

Edit the `.env.production` file and push your changes:

```shell
$ npx dotenv-vault push production
```

Neato.

## Deploy Anywhere

Build your encrypted `.env.vault`. Run the command:

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

## FAQ

### What happens if DOTENV_KEY is not set?

Dotenv Vault gracefully falls back to [dotenv](https://github.com/bkeepers/dotenv) when `DOTENV_KEY` is not set. This is useful for development.

### Should I commit my `.env` file?

No. We **strongly** recommend against committing your `.env` file to version control. It should only include environment-specific values such as database passwords or API keys. Your production database should have a different password than your development database.

### Should I commit my `.env.vault` file?

Yes. It is safe and recommended to do so. It contains your vault identifier at the vault provider (in this case [dotenv.org](https://dotenv.org)) and contains your encrypted values.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
