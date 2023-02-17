# dotenv_vault plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-dotenv_vault)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-dotenv_vault`, add it to your project by running:

```bash
fastlane add_plugin dotenv_vault
```

then at the top of your `Fastfile`:

```ruby
# Fastfile
dotenv_vault

# or if you want to configure non-standard path to .env.vault file
dotenv_vault(
  # vault_path: ".env.vault",
)
```

You can also set the `VAULT_PATH` environment variable to configure the path to the `.env.vault` file:

```bash
$ DOTENV_VAULT_PATH="../.env.vault" \
fastlane some_lane
```

## About dotenv_vault

Decrypt .env.vault file.

## Actions

### dotenv_vault

Decrypt .env.vault file.

#### Parameters

| Parameter     | Environment Variable | Default      |
| ------------- | -------------------- | ------------ |
| `:vault_path` | `DOTENV_VAULT_PATH`  | `.env.vault` |

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```bash
rake
```

To automatically fix many of the styling issues, use

```bash
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
