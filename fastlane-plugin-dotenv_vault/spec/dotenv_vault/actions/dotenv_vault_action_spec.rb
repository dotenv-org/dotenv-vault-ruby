require 'fastlane/plugin/dotenv_vault/actions/dotenv_vault_action'

describe Fastlane::Actions::DotenvVaultAction do
  describe '#run' do
    it 'calls DotenvVault.load' do
      expect(DotenvVault).to receive(:load)

      Fastlane::Actions::DotenvVaultAction.run(nil)
    end
  end
end
