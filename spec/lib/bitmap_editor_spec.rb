require 'lib/bitmap_editor'

RSpec.describe BitmapEditor do
  subject { editor }

  let(:editor) { described_class.new path }
  let(:path) { example_file_path }

  it { is_expected.to be_kind_of described_class }

  describe '#run' do
    subject(:run) { editor.run }

    let(:file_line_count) { 5 }
    let(:expected_output) { "OOOOO\nOOZZZ\nAWOOO\nOWOOO\nOWOOO\nOWOOO\n" }

    it { expect { run }.to output(expected_output).to_stdout }

    context 'when input file is not present' do
      let(:parser) { double 'InputParser', file_exists?: file_present }
      let(:file_present) { false }

      before { allow(editor).to receive(:input_parser).and_return parser }

      it 'returns immediately' do
        expect(editor).not_to receive :load_commands
      end
    end

    shared_examples_for 'image grid is not initialised' do
      let(:file) { array_to_file(file_content) }
      let(:file_content) { [command] }

      it { expect { run }.not_to raise_error }
    end

    context "when executing 'I' command" do
      subject(:image) { editor.image_grid }

      let(:file) { array_to_file(["I #{width} #{height}"]) }
      let(:path) { file.path }
      let(:width) { rand(1..10) }
      let(:height) { rand(1..10) }

      before { run }

      it { expect(editor.image_width).to eq width }
      it { expect(editor.image_height).to eq height }
    end

    context "when executing 'L' command" do
      subject(:image) { editor.image_grid }

      let(:file) { array_to_file(["I #{width} #{height}", command]) }
      let(:command) { "L #{x_coordinate} #{y_coordinate} #{colour}" }
      let(:path) { file.path }
      let(:width) { rand(1..10) }
      let(:height) { rand(1..10) }
      let(:x_coordinate) { rand(1..width) }
      let(:y_coordinate) { rand(1..height) }
      let(:colour) { 'C' }

      it_behaves_like 'image grid is not initialised'

      context 'when checking image grid' do
        subject(:image) { editor.image_grid }

        before { run }

        it { expect(image[y_coordinate - 1][x_coordinate - 1]).to eq colour }
      end

      context 'when x out of bounds' do
        let(:x_coordinate) { width + 1 }

        it { expect { run }.not_to raise_error }
      end
      context 'when y out of bounds' do
        let(:y_coordinate) { height + 1 }

        it { expect { run }.not_to raise_error }
      end
    end

    context "when executing 'V' command" do
      let(:file) { array_to_file(["I #{width} #{height}", command]) }
      let(:command) { "V #{x_coordinate} #{y1_coordinate} #{y2_coordinate} #{colour}" }
      let(:path) { file.path }
      let(:width) { rand(1..10) }
      let(:height) { rand(1..10) + 1 }
      let(:x_coordinate) { rand(1..width) }
      let(:y1_coordinate) { rand(1..height - 1) }
      let(:y2_coordinate) { rand(y1_coordinate..height) }
      let(:colour) { 'C' }

      it_behaves_like 'image grid is not initialised'

      context 'when checking image grid' do
        subject(:image) { editor.image_grid }

        before { run }

        it 'colours all vertical blocks' do
          for y_coordinate in y1_coordinate..y2_coordinate
            expect(image[y_coordinate - 1][x_coordinate - 1]).to eq colour
          end
        end
      end
    end

    context "when executing 'H' command" do
      let(:file) { array_to_file(["I #{width} #{height}", command]) }
      let(:command) { "H #{x1_coordinate} #{x2_coordinate} #{y_coordinate} #{colour}" }
      let(:path) { file.path }
      let(:width) { rand(1..10) + 1 }
      let(:height) { rand(1..10) }
      let(:x1_coordinate) { rand(1..width - 1) }
      let(:x2_coordinate) { rand(x1_coordinate..width) }
      let(:y_coordinate) { rand(1..height) }
      let(:colour) { 'C' }

      it_behaves_like 'image grid is not initialised'

      context 'when checking image grid' do
        subject(:image) { editor.image_grid }

        before { run }

        it 'colours all horizontal blocks' do
          for x_coordinate in x1_coordinate..x2_coordinate
            expect(image[y_coordinate - 1][x_coordinate - 1]).to eq colour
          end
        end
      end
    end

    context "when executing 'C' command" do
      let(:file) { array_to_file(["I #{width} #{height}", "L #{x_coordinate} #{y_coordinate} #{colour}", command]) }
      let(:command) { 'C' }
      let(:path) { file.path }
      let(:width) { rand(1..10) }
      let(:height) { rand(1..10) }
      let(:x_coordinate) { rand(1..width) }
      let(:y_coordinate) { rand(1..height) }
      let(:colour) { 'C' }
      let(:expected_grid) { Array.new(height) { Array.new(width, BitmapEditor::DEFAULT_BLOCK_COLOUR) } }

      it_behaves_like 'image grid is not initialised'

      context 'when checking image grid' do
        subject(:image) { editor.image_grid }

        before { run }

        it { is_expected.to match_array expected_grid }
      end
    end

    context "when executing 'S' command" do
      subject(:image) { editor.image_grid }

      let(:file) { array_to_file(["I #{width} #{height}", "L #{x_coordinate} #{y_coordinate} #{colour}", command]) }
      let(:command) { 'S' }
      let(:path) { file.path }
      let(:width) { rand(1..10) }
      let(:height) { rand(1..10) }
      let(:x_coordinate) { rand(1..width) }
      let(:y_coordinate) { rand(1..height) }
      let(:colour) { 'C' }
      let(:grid) do
        grid = Array.new(height) { Array.new(width, BitmapEditor::DEFAULT_BLOCK_COLOUR) }
        grid[y_coordinate - 1][x_coordinate - 1] = colour
        grid
      end
      let(:expected_output) { "#{grid.map(&:join).join("\n")}\n" }

      it { expect { run }.to output(expected_output).to_stdout }

      context 'when image not initialised' do
        let(:file) { array_to_file(file_content) }
        let(:file_content) { [command] }

        it { expect { run }.to output("There's no image to show\n").to_stdout }
      end
    end
  end
end
