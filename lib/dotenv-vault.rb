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
    DotenvVault.logger.info("[dotenv-vault] Loading env from encrypted .env.vault") if DotenvVault.logger

    parsed = parse_vault(*filenames)
    
    # Set ENV
    parsed.each { |k, v| ENV[k] ||= v }

    { parsed: parsed }
  end

  # Vault: Overload from .env.vault
  #
  # Decrypts and overloads to ENV
  def overload_vault(*filenames)
    DotenvVault.logger.info("[dotenv-vault] Overloading env from encrypted .env.vault") if DotenvVault.logger

    parsed = parse_vault(*filenames)
    
    # Set ENV
    parsed.each { |k, v| ENV[k] = v }

    { parsed: parsed }
  end

  def parse_vault(*filenames)
    # DOTENV_KEY=development/key_1234
    #
    # Warn the developer unless present
    raise NotFoundDotenvKey, "NOT_FOUND_DOTENV_KEY: Cannot find ENV['DOTENV_KEY']" unless present?(dotenv_key)

    # Parse .env.vault
    parsed = Dotenv.parse(vault_path)

    # handle scenario for comma separated keys - for use with key rotation
    # example: DOTENV_KEY="dotenv://:key_1234@dotenv.org/vault/.env.vault?environment=prod,dotenv://:key_7890@dotenv.org/vault/.env.vault?environment=prod"
    keys = dotenv_key.split(',')

    decrypted = nil
    keys.each_with_index do |split_dotenv_key, index|
      begin
        # Get full key
        key = split_dotenv_key.strip

        # Get instructions for decrypt
        attrs = instructions(parsed, key)

        # Decrypt
        decrypted = decrypt(attrs[:ciphertext], attrs[:key])

        break
      rescue => error
        # last key
        raise error if index >= keys.length - 1
        # try next key
      end
    end

    # Parse decrypted .env string
    Dotenv::Parser.call(decrypted, true)
  end

  def using_vault?
    dotenv_key_present? && dotenv_vault_present?
  end

  def dotenv_key_present?
    present?(dotenv_key) && dotenv_vault_present?
  end

  def dotenv_key
    return ENV["DOTENV_KEY"] if present?(ENV["DOTENV_KEY"])

    ""
  end

  def dotenv_vault_present?
    File.file?(vault_path)
  end

  def vault_path
    ".env.vault"
  end

  def present?(str)
    !(str.nil? || str.empty?)
  end

  def decrypt(ciphertext, key)
    key = key[-64..-1] # last 64 characters. allows for passing keys with preface like key_*****

    raise InvalidDotenvKey, "INVALID_DOTENV_KEY: Key part must be 64 characters long (or more)" unless key && key.bytesize == 64

    lockbox = Lockbox.new(key: key, encode: true)
    begin
      lockbox.decrypt(ciphertext)
    rescue Lockbox::Error
      raise DecryptionFailed, "DECRYPTION_FAILED: Please check your DOTENV_KEY"
    end
  end

  def instructions(parsed, split_dotenv_key)
    # Parse DOTENV_KEY. Format is a URI
    uri = URI.parse(split_dotenv_key) # dotenv://:key_1234@dotenv.org/vault/.env.vault?environment=production

    # Get decrypt key
    key = uri.password
    raise InvalidDotenvKey, "INVALID_DOTENV_KEY: Missing key part" unless present?(key)

    # Get environment
    params = Hash[URI::decode_www_form(uri.query.to_s)]
    environment = params["environment"]
    raise InvalidDotenvKey, "INVALID_DOTENV_KEY: Missing environment part" unless present?(environment)

    # Get ciphertext payload
    environment_key = "DOTENV_VAULT_#{environment.upcase}"
    ciphertext = parsed[environment_key] # DOTENV_VAULT_PRODUCTION
    raise NotFoundDotenvEnvironment, "NOT_FOUND_DOTENV_ENVIRONMENT: Cannot locate #{environment_key} in .env.vault" unless ciphertext

    {
      ciphertext: ciphertext,
      key: key
    }
  end
end
