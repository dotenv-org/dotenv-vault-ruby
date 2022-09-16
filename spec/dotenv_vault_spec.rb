require "spec_helper"

RSpec.describe DotenvVault do
  let(:test_path) { "test/fixtures/.env" }
  let(:dotenv_key) { "key_1111111111111111111111111111111111111111111111111111111111111111" }
  let(:dotenv_environment) { "production" }

  before do
    Dir.chdir(File.expand_path("../fixtures", __FILE__))
  end

  shared_examples "load" do
    context "with no args" do
      let(:env_files) { [] }

      it "defaults to .env" do
        expect(Dotenv::Environment).to receive(:new).with(expand(".env"), anything)
          .and_return(double(apply: {}, apply!: {}))
        subject
      end
    end

    context "with a tilde path" do
      let(:env_files) { ["~/.env"] }

      it "expands the path" do
        expected = expand("~/.env")
        allow(File).to receive(:exist?) { |arg| arg == expected }
        expect(Dotenv::Environment).to receive(:new).with(expected, anything)
          .and_return(double(apply: {}, apply!: {}))
        subject
      end
    end

    context "with multiple files" do
      let(:env_files) { [".env", fixture_path("plain.env")] }

      let(:expected) do
        {"OPTION_A" => "1",
         "OPTION_B" => "2",
         "OPTION_C" => "3",
         "OPTION_D" => "4",
         "OPTION_E" => "5",
         "PLAIN" => "true",
         "BASIC" => "basic"}
      end

      it "loads all files" do
        subject
        expected.each do |key, value|
          expect(ENV[key]).to eq(value)
        end
      end

      it "returns hash of loaded environments" do
        expect(subject).to eq(expected)
      end
    end
  end

  describe "#load_vault" do
    subject { DotenvVault.load }

    before do
      ENV["DOTENV_ENVIRONMENT"] = dotenv_environment
      ENV["DOTENV_KEY"] = dotenv_key
    end

    it "reads .env.vault" do
      subject
      expect(ENV["BASIC"]).to eql("production")
    end

    context "when value is already set in ENV" do
      before do
        ENV["BASIC"] = "previously set"
      end

      it "does not override it" do
        subject
        expect(ENV["BASIC"]).to eql("previously set")
      end
    end

    context "environment is not found in the .env.vault file" do
      before do
        ENV["DOTENV_ENVIRONMENT"] = "does-not-exist"
      end

      it "raises an error" do
        expect do
          subject
        end.to raise_error(DotenvVault::NotFoundDotenvEnvironment)
      end
    end

    context "incorrect key" do
      let(:dotenv_key) { "key_2111111111111111111111111111111111111111111111111111111111111112" }

      it "raises error" do
        expect do
          subject
        end.to raise_error(DotenvVault::DecryptionFailed)
      end
    end

    context "malformed key" do
      let(:dotenv_key) { "key_1234" }

      it "raises error" do
        expect do
          subject
        end.to raise_error(DotenvVault::InvalidDotenvKey)
      end
    end
  end

  describe "#overload_vault" do
    subject { DotenvVault.overload }

    before do
      ENV["BASIC"] = "already set"
      ENV["DOTENV_ENVIRONMENT"] = dotenv_environment
      ENV["DOTENV_KEY"] = dotenv_key
    end

    it "reads .env.vault and overrides it" do
      subject
      expect(ENV["BASIC"]).to eql("production")
    end

    context "incorrect key" do
      let(:dotenv_key) { "key_2111111111111111111111111111111111111111111111111111111111111112" }

      it "raises error" do
        expect do
          subject
        end.to raise_error(DotenvVault::DecryptionFailed)
      end
    end

    context "malformed key" do
      let(:dotenv_key) { "key_1234" }

      it "raises error" do
        expect do
          subject
        end.to raise_error(DotenvVault::InvalidDotenvKey)
      end
    end
  end

  describe "load" do
    let(:env_files) { [] }
    subject { DotenvVault.load(*env_files) }

    it_behaves_like "load"

    it "initializes the Environment with a truthy is_load" do
      expect(Dotenv::Environment).to receive(:new).with(anything, true)
        .and_return(double(apply: {}, apply!: {}))
      subject
    end

    context "when the file does not exist" do
      let(:env_files) { [".env_does_not_exist"] }

      it "fails silently" do
        expect { subject }.not_to raise_error
        expect(ENV.keys).to eq(@env_keys)
      end
    end
  end

  describe "load!" do
    let(:env_files) { [] }
    subject { DotenvVault.load!(*env_files) }

    it_behaves_like "load"

    it "initializes Environment with truthy is_load" do
      expect(Dotenv::Environment).to receive(:new).with(anything, true)
        .and_return(double(apply: {}, apply!: {}))
      subject
    end

    context "when one file exists and one does not" do
      let(:env_files) { [".env", ".env_does_not_exist"] }

      it "raises an Errno::ENOENT error" do
        expect { subject }.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe "overload" do
    let(:env_files) { [fixture_path("plain.env")] }
    subject { Dotenv.overload(*env_files) }
    it_behaves_like "load"

    it "initializes the Environment with a falsey is_load" do
      expect(Dotenv::Environment).to receive(:new).with(anything, false)
        .and_return(double(apply: {}, apply!: {}))
      subject
    end

    context "when loading a file containing already set variables" do
      let(:env_files) { [fixture_path("plain.env")] }

      it "overrides any existing ENV variables" do
        ENV["OPTION_A"] = "predefined"

        subject

        expect(ENV["OPTION_A"]).to eq("1")
      end
    end

    context "when the file does not exist" do
      let(:env_files) { [".env_does_not_exist"] }

      it "fails silently" do
        expect { subject }.not_to raise_error
        expect(ENV.keys).to eq(@env_keys)
      end
    end
  end

  describe "overload!" do
    let(:env_files) { [fixture_path("plain.env")] }
    subject { Dotenv.overload!(*env_files) }
    it_behaves_like "load"

    it "initializes the Environment with a falsey is_load" do
      expect(Dotenv::Environment).to receive(:new).with(anything, false)
        .and_return(double(apply: {}, apply!: {}))
      subject
    end

    context "when loading a file containing already set variables" do
      let(:env_files) { [fixture_path("plain.env")] }

      it "overrides any existing ENV variables" do
        ENV["OPTION_A"] = "predefined"
        subject
        expect(ENV["OPTION_A"]).to eq("1")
      end
    end

    context "when one file exists and one does not" do
      let(:env_files) { [".env", ".env_does_not_exist"] }

      it "raises an Errno::ENOENT error" do
        expect { subject }.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe "with an instrumenter" do
    let(:instrumenter) { double("instrumenter", instrument: {}) }
    before { Dotenv.instrumenter = instrumenter }
    after { Dotenv.instrumenter = nil }

    describe "load" do
      it "instruments if the file exists" do
        expect(instrumenter).to receive(:instrument) do |name, payload|
          expect(name).to eq("dotenv.load")
          expect(payload[:env]).to be_instance_of(Dotenv::Environment)
          {}
        end
        DotenvVault.load
      end

      it "does not instrument if file does not exist" do
        expect(instrumenter).to receive(:instrument).never
        DotenvVault.load ".doesnotexist"
      end
    end
  end

  describe "require keys" do
    let(:env_files) { [".env", fixture_path("bom.env")] }

    before { DotenvVault.load(*env_files) }

    it "raises exception with not defined mandatory ENV keys" do
      expect { Dotenv.require_keys("BOM", "TEST") }.to raise_error(
        Dotenv::MissingKeys,
        'Missing required configuration key: ["TEST"]'
      )
    end
  end

  describe "parse" do
    let(:env_files) { [] }
    subject { Dotenv.parse(*env_files) }

    context "with no args" do
      let(:env_files) { [] }

      it "defaults to .env" do
        expect(Dotenv::Environment).to receive(:new).with(expand(".env"),
          anything)
        subject
      end
    end

    context "with a tilde path" do
      let(:env_files) { ["~/.env"] }

      it "expands the path" do
        expected = expand("~/.env")
        allow(File).to receive(:exist?) { |arg| arg == expected }
        expect(Dotenv::Environment).to receive(:new).with(expected, anything)
        subject
      end
    end

    context "with multiple files" do
      let(:env_files) { [".env", fixture_path("plain.env")] }

      let(:expected) do
        {"OPTION_A" => "1",
         "OPTION_B" => "2",
         "OPTION_C" => "3",
         "OPTION_D" => "4",
         "OPTION_E" => "5",
         "PLAIN" => "true",
         "BASIC" => "basic"}
      end

      it "does not modify ENV" do
        subject
        expected.each do |key, _value|
          expect(ENV[key]).to be_nil
        end
      end

      it "returns hash of parsed key/value pairs" do
        expect(subject).to eq(expected)
      end
    end

    it "initializes the Environment with a falsey is_load" do
      expect(Dotenv::Environment).to receive(:new).with(anything, false)
      subject
    end

    context "when the file does not exist" do
      let(:env_files) { [".env_does_not_exist"] }

      it "fails silently" do
        expect { subject }.not_to raise_error
        expect(subject).to eq({})
      end
    end
  end

  describe "Unicode" do
    subject { fixture_path("bom.env") }

    it "loads a file with a Unicode BOM" do
      expect(DotenvVault.load(subject)).to eql("BOM" => "UTF-8")
    end

    it "fixture file has UTF-8 BOM" do
      contents = File.binread(subject).force_encoding("UTF-8")
      expect(contents).to start_with("\xEF\xBB\xBF".force_encoding("UTF-8"))
    end
  end

  def expand(path)
    File.expand_path path
  end
end
