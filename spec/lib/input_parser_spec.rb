require 'lib/input_parser'
require 'lib/command'

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

  describe '#parse' do
    subject(:parse) { parser.parse }

    def build_command(key, args)
      Command.new key, args
    end

    let(:expected_result) do
      [
        build_command('I', %w[5 6]),
        build_command('L', %w[1 3 A]),
        build_command('V', %w[2 3 6 W]),
        build_command('H', %w[3 5 2 Z]),
        build_command('S', [])
      ]
    end

    it { is_expected.to match_array expected_result }

    context 'when file contains blank line' do
      let(:file) { array_to_file(file_content) }
      let(:file_content) { ['I 5 6', invalid_line] }
      let(:invalid_line) { '' }
      let(:expected_result) { [build_command('I', %w[5 6]), nil] }
      let(:path) { file.path }

      it 'nil for blank line' do
        is_expected.to match_array expected_result
      end
    end
  end
end
