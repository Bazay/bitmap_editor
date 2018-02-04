require 'lib/input_parser'

RSpec.describe InputParser do
  subject { parser }

  let(:parser) { described_class.new path }
  let(:path) { example_file_path }

  describe '#file_present?' do
    subject { parser.file_present? }

    let(:file_exists) { true }

    before { allow(parser).to receive(:file_exists?).and_return file_exists }

    it { is_expected.to eq true }

    context 'when path empty' do
      let(:path) { '' }

      it { is_expected.to eq false }
    end

    context 'when file does not exist' do
      let(:file_exists) { false }

      it { is_expected.to eq false }
    end
  end

  describe '#parse!' do
    subject { parser.parse! }

    let(:expected_output) do
      [
        { command: 'I', args: [5, 6] },
        { command: 'L', args: [1, 3, 'A'] },
        { command: 'V', args: [2, 3, 6, 'W'] },
        { command: 'H', args: [3, 5, 2, 'Z'] },
        { command: 'S', args: [] }
      ]
    end

    it 'parses file correctly' do
      is_expected.to match_array expected_output
    end
  end
end
