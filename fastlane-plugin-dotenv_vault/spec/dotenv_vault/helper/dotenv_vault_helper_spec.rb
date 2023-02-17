require 'fastlane/plugin/dotenv_vault/helper/dotenv_vault_helper'

describe Fastlane::Helper::DotenvVaultHelper do
  before do
    @filenames = %w[.env .env.test]
  end

  describe '.load' do
    it 'calls DotenvVault.load' do
      expect(DotenvVault).to receive(:load).with(*@filenames)

      described_class.load(*@filenames)
    end
  end

  describe '.load!' do
    it 'calls DotenvVault.load!' do
      expect(DotenvVault).to receive(:load!).with(*@filenames)

      described_class.load!(*@filenames)
    end
  end

  describe '.overload' do
    it 'calls DotenvVault.overload' do
      expect(DotenvVault).to receive(:overload).with(*@filenames)

      described_class.overload(*@filenames)
    end
  end

  describe '.overload!' do
    it 'calls DotenvVault.overload!' do
      expect(DotenvVault).to receive(:overload!).with(*@filenames)

      described_class.overload!(*@filenames)
    end
  end

  describe '.parse' do
    it 'calls DotenvVault.parse' do
      expect(DotenvVault).to receive(:parse).with(*@filenames)

      described_class.parse(*@filenames)
    end
  end
end
