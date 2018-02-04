require 'lib/bitmap_editor'

RSpec.describe BitmapEditor do
  subject { editor }

  let(:editor) { described_class.new path }
  let(:path) { 'path/example.txt' }

  it { is_expected.to be_kind_of described_class }

  describe '#run' do
    subject { editor.run }

    context 'when input file provided' do
      let(:parser) { double 'BitmapEditor::InputParser', file_present?: file_present }
      let(:file_present) { true }

      before { allow(editor).to receive(:input_parser).and_return parser }

      it 'load commands' do
        expect(editor).to receive :load_commands
        subject
      end

      context 'when input file is not present' do
        let(:file_present) { false }

        it 'returns immediately' do
          expect(editor).not_to receive :load_commands
        end
      end
    end
  end
end
