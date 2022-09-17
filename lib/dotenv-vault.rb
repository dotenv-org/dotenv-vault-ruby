require "uri"
require "dotenv"
require "lockbox"
require "dotenv-vault/version"
require "logger"

module DotenvVault
  class NotFoundDotenvKey < ArgumentError; end
  class NotFoundDotenvEnvironment < ArgumentError; end
  class NotFoundDotenvVault < ArgumentError; end
  class InvalidDotenvKey < ArgumentError; end
  class DecryptionFailed < StandardError; end

  include ::Dotenv

  class << self
    attr_accessor :instrumenter

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end

  module_function

  def load(*filenames)
    if using_vault?
      load_vault(*filenames)
    else
      Dotenv.load(*filenames) # fallback
    end
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def load!(*filenames)
    if using_vault?
      load_vault(*filenames)
    else
      Dotenv.load!(*filenames)
    end
  end

  # same as `load`, but will override existing values in `ENV`
  def overload(*filenames)
    if using_vault?
      overload_vault(*filenames)
    else
      Dotenv.overload(*filenames)
    end
  end

  # same as `overload`, but raises Errno:ENOENT if any files don't exist
  def overload!(*filenames)
    if using_vault?
      overload_vault(*filenames)
    else
      Dotenv.overload!(*filenames)
    end
  end

  # returns a hash of parsed key/value pairs but does not modify ENV
  def parse(*filenames)
    if using_vault?
      parse_vault(*filenames)
    else
      Dotenv.parse(*filenames)
    end
  end

  # Internal: Helper to expand list of filenames.
  #
  # Returns a hash of all the loaded environment variables.
  def with(*filenames)
    Dotenv.with(*filenames)
  end

  def instrument(name, payload = {}, &block)
    Dotenv.instrument(name, payload = {}, &block)
  end

  def require_keys(*keys)
    Dotenv.require_keys(*keys)
  end

  def ignoring_nonexistent_files
    Dotenv.ignoring_nonexistent_files
  end

  # Vault: Load from .env.vault
  #
  # Decrypts and loads to ENV
  def load_vault(*filenames)
    DotenvVault.logger.info("[dotenv-vault] Loading .env.vault") if DotenvVault.logger

    parsed = parse_vault(*filenames)
    
    # Set ENV
    parsed.each { |k, v| ENV[k] ||= v }

    { parsed: parsed }
  end

  # Vault: Overload from .env.vault
  #
  # Decrypts and overloads to ENV
  def overload_vault(*filenames)
    DotenvVault.logger.info("[dotenv-vault] Overloading .env.vault") if DotenvVault.logger

    parsed = parse_vault(*filenames)
    
    # Set ENV
    parsed.each { |k, v| ENV[k] = v }

    { parsed: parsed }
  end

  def parse_vault(*filenames)
    # DOTENV_KEY=development/key_1234
    #
    # Warn the developer unless formatted correctly
    raise NotFoundDotenvKey, "NOT_FOUND_DOTENV_KEY: Cannot find ENV['DOTENV_KEY']" unless present?(ENV["DOTENV_KEY"])

    # Parse DOTENV_KEY. Format is a URI
    uri = URI.parse(ENV["DOTENV_KEY"]) # dotenv://:key_1234@dotenv.org/vault/.env.vault?environment=production

    # Get decrypt key
    key = uri.password
    raise InvalidDotenvKey, "INVALID_DOTENV_KEY: Missing key part" unless present?(key)

    # Get environment
    params = Hash[URI::decode_www_form(uri.query.to_s)]
    environment = params["environment"]
    raise InvalidDotenvKey, "INVALID_DOTENV_KEY: Missing environment part" unless present?(environment)

    # Get vault path
    vault_path = uri.path.gsub("/vault/", "") # /vault/.env.vault => .env.vault
    raise NotFoundDotenvVault, "NotFoundDotenvVault: Cannot find .env.vault at #{vaultPath}" unless File.file?(vault_path)

    # Parse .env.vault
    parsed = Dotenv.parse(vault_path)

    # Get ciphertext
    environment_key = "DOTENV_VAULT_#{environment.upcase}"
    ciphertext = parsed[environment_key] # DOTENV_VAULT_PRODUCTION
    raise NotFoundDotenvEnvironment, "NOT_FOUND_DOTENV_ENVIRONMENT: Cannot locate #{environment_key} in .env.vault" unless ciphertext

    # Decrypt ciphertext
    decrypted = decrypt(ciphertext, key)

    # Parse decrypted .env string
    Dotenv::Parser.call(decrypted, true)
  end

  def using_vault?
    present?(ENV["DOTENV_KEY"])
  end

  def present?(str)
    !(str.nil? || str.empty?)
  end

  def decrypt(ciphertext, key)
    key = key[-64..-1] # last 64 characters. allows for passing keys with preface like key_*****

    raise InvalidDotenvKey, "INVALID_DOTENV_KEY: Key part must be 64 characters long (or more)" unless key.bytesize == 64

    lockbox = Lockbox.new(key: key, encode: true)
    begin
      lockbox.decrypt(ciphertext)
    rescue Lockbox::Error
      raise DecryptionFailed, "DECRYPTION_FAILED: Please check your DOTENV_KEY"
    end
  end
end
