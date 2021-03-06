require "spec_helper"

describe Bummr::Log do
  let(:object) { Object.new }
  let(:message) { "test message" }

  before do
    `mkdir -p log`
    object.extend(Bummr::Log)
  end

  after do
    `rm log/bummr.log`
  end

  describe "#log" do
    it "puts the message" do
      allow(STDOUT).to receive(:puts)

      object.log message

      expect(STDOUT).to have_received(:puts).with(message)
    end

    it "outputs the message to log/bummr.log" do
      object.log message

      result = `cat log/bummr.log`

      expect(result).to eq message + "\n"
    end
  end
end
