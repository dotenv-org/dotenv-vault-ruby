require 'fastlane/plugin/dotenv_vault/logger'

describe Fastlane::DotenvVault::Logger do
  describe '.debug' do
    it 'should call UI.verbose' do
      expect(Fastlane::UI).to receive(:verbose)
      subject.debug('test')
    end
  end

  describe '.info' do
    it 'should call UI.message' do
      expect(Fastlane::UI).to receive(:message)
      subject.info('test')
    end
  end

  describe '.warn' do
    it 'should call UI.important' do
      expect(Fastlane::UI).to receive(:important)
      subject.warn('test')
    end
  end

  describe '.error' do
    it 'should call UI.error' do
      expect(Fastlane::UI).to receive(:error)
      subject.error('test')
    end
  end

  describe '.fatal' do
    it 'should call UI.error' do
      expect(Fastlane::UI).to receive(:error)
      subject.fatal('test')
    end
  end

  describe '.unknown' do
    it 'should call UI.message' do
      expect(Fastlane::UI).to receive(:message)
      subject.unknown('test')
    end
  end

  describe '.log' do
    it 'should call UI.message' do
      expect(Fastlane::UI).to receive(:message)
      subject.log('test', 'test')
    end
  end

  describe '.<<' do
    it 'should call UI.message' do
      expect(Fastlane::UI).to receive(:message)
      subject << 'test'
    end
  end

  describe '.close' do
    it 'should do nothing' do
      expect(subject.close).to be_nil
    end
  end

  describe '.reopen' do
    it 'should do nothing' do
      expect(subject.reopen).to be_nil
    end
  end

  describe '.flush' do
    it 'should do nothing' do
      expect(subject.flush).to be_nil
    end
  end

  describe '.level' do
    it 'should do nothing' do
      expect(subject.level).to be_nil
    end
  end

  describe '.level=' do
    it 'should do nothing' do
      expect(subject.level = 'test').to eq('test')
    end
  end

  describe '.new' do
    it 'should return a new Fastlane::DotenvVault::Logger' do
      expect(subject).to be_a(Fastlane::DotenvVault::Logger)
    end
  end
end
