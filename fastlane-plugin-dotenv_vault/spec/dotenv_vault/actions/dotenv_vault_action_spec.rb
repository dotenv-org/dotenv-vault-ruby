require 'fastlane/plugin/dotenv_vault/actions/dotenv_vault_action'

describe Fastlane::Actions::DotenvVaultAction do
  let(:action) { Fastlane::Actions::DotenvVaultAction }

  describe '#run' do
    it 'calls DotenvVault.load' do
      expect(DotenvVault).to receive(:load)
      params = FastlaneCore::Configuration.create(action.available_options, {})
      action.run(params)
    end

    it 'calls DotenvVault.load with DOTENV_VAULT_PATH' do
      stub_const('ENV', 'DOTENV_VAULT_PATH' => 'test')
      expect(DotenvVault).to receive(:load).with('test')
      params = FastlaneCore::Configuration.create(action.available_options, {})
      action.run(params)
    end

    it 'calls DotenvVault.load with :vault_path param' do
      expect(DotenvVault).to receive(:load).with('test')
      params = FastlaneCore::Configuration.create(action.available_options, {
        vault_path: 'test'
      })
      action.run(params)
    end
  end
end
