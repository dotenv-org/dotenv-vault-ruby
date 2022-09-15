require "dotenv"
require "dotenv-vault/version"

module DotenvVault
  class Error < StandardError; end

  class << self
    attr_accessor :instrumenter
  end

  module_function

  def load(*filenames)
    Dotenv.load(*filenames)
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def load!(*filenames)
    Dotenv.load!(*filenames)
  end

  # same as `load`, but will override existing values in `ENV`
  def overload(*filenames)
    Dotenv.overload(*filenames)
  end

  # same as `overload`, but raises Errno:ENOENT if any files don't exist
  def overload!(*filenames)
    Dotenv.overload!(*filenames)
  end

  # returns a hash of parsed key/value pairs but does not modify ENV
  def parse(*filenames)
    Dotenv.parse(*filenames)
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
end
