require 'lib/bitmap_editor'

RSpec.describe BitmapEditor do
  subject { editor }

  let(:editor) { described_class.new path }
  let(:path) { example_file_path }

  it { is_expected.to be_kind_of described_class }

  describe '#run' do
    subject(:run) { editor.run }

    let(:file_line_count) { 5 }

    it { expect { run }.to change { editor.commands.count }.by file_line_count }

    context 'when input file is not present' do
      let(:parser) { double 'InputParser', file_exists?: file_present }
      let(:file_present) { false }

      before { allow(editor).to receive(:input_parser).and_return parser }

      it 'returns immediately' do
        expect(editor).not_to receive :load_commands
      end
    end

    context "when executing 'I' command" do
      subject(:image) { editor.image_grid }

      let(:file) { array_to_file(["I #{width} #{height}"]) }
      let(:path) { file.path }
      let(:width) { rand(1..10) }
      let(:height) { rand(1..10) }

      before { run }

      it { expect(image.size).to eq width }
      it { expect(image.first.size).to eq height }
    end

    context "when executing 'L' command" do
      subject(:image) { editor.image_grid }

      let(:file) { array_to_file(["I #{width} #{height}", "L #{x_coord} #{y_coord} #{colour}"]) }
      let(:file_path) { file.path }
      let(:width) { rand(1..10) }
      let(:height) { rand(1..10) }
      let(:x_coordinate) { rand(1..width) }
      let(:y_coordinate) { rand(1..height) }
      let(:colour) { 'A' }

      before { run }

      it { expect(image[x_coordinate][y_coordinate]).to eq colour }
    end
  end
end
