require 'lib/command'

RSpec.describe Command do
  subject { command }

  let(:command) { described_class.new command_string, arguments }

  describe '#valid?' do
    subject { command.valid? }

    context "when command 'I'" do
      let(:command_string) { 'I' }
      let(:arguments) { [nm_arg.call, nm_arg.call] }
      let(:nm_arg) { -> { rand(1..250) } }

      it { is_expected.to eq true }

      context "when argument count invalid" do
        let(:arguments) { [] }

        it { is_expected.to eq false }
      end

      context 'when argument is not integer' do
        it { is_expected.to eq false }
      end
    end
  end
end
