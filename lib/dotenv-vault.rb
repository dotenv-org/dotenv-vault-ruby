require "dotenv"
require "lockbox"
require "dotenv-vault/version"

module DotenvVault
  class NotFoundDotenvKey < ArgumentError; end
  class NotFoundDotenvEnvironment < ArgumentError; end
  class NotFoundDotenvVault < ArgumentError; end
  class InvalidDotenvKey < ArgumentError; end
  class DecryptionFailed < StandardError; end

  include ::Dotenv

  class << self
    attr_accessor :instrumenter
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
    parsed = parse_vault(*filenames)
    
    # Set ENV
    parsed.each { |k, v| ENV[k] ||= v }

    { parsed: parsed }
  end

  # Vault: Overload from .env.vault
  #
  # Decrypts and overloads to ENV
  def overload_vault(*filenames)
    parsed = parse_vault(*filenames)
    
    # Set ENV
    parsed.each { |k, v| ENV[k] = v }

    { parsed: parsed }
  end

  def parse_vault(*filenames)
    # Warn the developer unless both are set
    raise NotFoundDotenvKey, "NOT_FOUND_DOTENV_KEY: Cannot find ENV['DOTENV_KEY']" unless present?(ENV["DOTENV_KEY"])
    raise NotFoundDotenvEnvironment, "NOT_FOUND_DOTENV_ENVIRONMENT: Cannot find ENV['DOTENV_ENVIRONMENT']" unless present?(ENV["DOTENV_ENVIRONMENT"])

    # Locate .env.vault
    vault_path = ".env.vault"
    raise NotFoundDotenvVault, "NotFoundDotenvVault: Cannot find .env.vault at ${vaultPath}" unless File.file?(vault_path)

    # Parse .env.vault
    parsed = Dotenv.parse(vault_path)

    # Get ciphertext
    ciphertext = parsed["DOTENV_VAULT_#{ENV["DOTENV_ENVIRONMENT"].upcase}"] # DOTENV_VAULT_PRODUCTION

    # Decrypt ciphertext
    decrypted = decrypt(ciphertext)

    # Parse decrypted .env string
    Dotenv::Parser.call(decrypted, true)
  end

  def using_vault?
    present?(ENV["DOTENV_ENVIRONMENT"]) && present?(ENV["DOTENV_KEY"])
  end

  def require_dotenv_key_and_dotenv_environment!
  end

  def present?(str)
    !(str.nil? || str.empty?)
  end

  def decrypt(ciphertext)
    raise NotFoundDotenvKey, "NOT_FOUND_DOTENV_KEY: Cannot find ENV['DOTENV_KEY']" unless present?(ENV["DOTENV_KEY"])

    key = ENV["DOTENV_KEY"][-64..-1] # last 64 characters. allows for passing keys with preface like key_*****

    raise InvalidDotenvKey, "INVALID_DOTENV_KEY: It must be 64 characters long (or more)" unless key.to_s.length == 64

    lockbox = Lockbox.new(key: key, encode: true)
    begin
      lockbox.decrypt(ciphertext)
    rescue Lockbox::Error
      raise DecryptionFailed, "DECRYPTION_FAILED: Please check your DOTENV_KEY"
    end
  end
end
