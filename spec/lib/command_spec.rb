require 'lib/command'

RSpec.describe Command do
  subject { command }

  let(:command) { described_class.new command_key, arguments }
  let(:min_numeric_value) { described_class::ARGUMENT_NUMERIC_MINIMUM }
  let(:max_numeric_value) { described_class::ARGUMENT_NUMERIC_MAXIMUM }
  let(:length_string_argument) { described_class::ARGUMENT_STRING_LENGTH }

  def random_numeric_argument
    # CLI interprets all args as string, hence #to_s
    rand(min_numeric_value..max_numeric_value).to_s
  end

  def random_string_argument
    ('A'..'Z').to_a.sample
  end

  shared_examples_for 'invalid argument length' do
    let(:arguments) { [] }

    before { command.valid? }

    it { expect(command.errors[:base][:messages].count).to eq 1 }
  end
  shared_examples_for 'invalid string argument' do
    let(:invalid_argument) { random_string_argument }

    before { command.valid? }

    it { expect(command.errors[:minimum][:messages].count).to eq 1 }
  end
  shared_examples_for 'invalid numeric argument too small' do
    let(:invalid_argument) { (min_numeric_value - 1).to_s }

    before { command.valid? }

    it { expect(command.errors[:minimum][:messages].count).to eq 1 }
  end
  shared_examples_for 'invalid numeric argument too large' do
    let(:invalid_argument) { (max_numeric_value + 1).to_s }

    before { command.valid? }

    it { expect(command.errors[:maximum][:messages].count).to eq 1 }
  end
  shared_examples_for 'invalid string argument not a char' do
    let(:invalid_argument) { Array.new((length_string_argument + 1)) { random_string_argument }.join }

    before { command.valid? }

    it { expect(command.errors[:length][:messages].count).to eq 1 }
  end
  shared_examples_for 'numeric argument' do
    it_behaves_like 'invalid string argument'
    it_behaves_like 'invalid numeric argument too small'
    it_behaves_like 'invalid numeric argument too large'
  end
  shared_examples_for 'string argument' do
    it_behaves_like 'invalid string argument not a char'
  end

  context "when command 'I'" do
    let(:command_key) { 'I' }
    let(:arguments) { [random_numeric_argument, random_numeric_argument] }

    it { is_expected.to be_valid }

    it_behaves_like 'invalid argument length'
    it_behaves_like 'numeric argument' do
      let(:arguments) { [random_numeric_argument, invalid_argument] }
    end
  end

  context "when command 'L'" do
    let(:command_key) { 'L' }
    let(:arguments) { [random_numeric_argument, random_numeric_argument, random_string_argument] }

    it { is_expected.to be_valid }

    it_behaves_like 'invalid argument length'
    it_behaves_like 'numeric argument' do
      let(:arguments) { [random_numeric_argument, invalid_argument, random_string_argument] }
    end
    it_behaves_like 'string argument' do
      let(:arguments) { [random_numeric_argument, random_numeric_argument, invalid_argument] }
    end
  end

  context "when command 'V" do
    let(:command_key) { 'V' }
    let :arguments do
      [random_numeric_argument, random_numeric_argument, random_numeric_argument, random_string_argument]
    end

    it { is_expected.to be_valid }

    it_behaves_like 'invalid argument length'
    it_behaves_like 'numeric argument' do
      let(:arguments) { [random_numeric_argument, random_numeric_argument, invalid_argument, random_string_argument] }
    end
    it_behaves_like 'string argument' do
      let(:arguments) { [random_numeric_argument, random_numeric_argument, random_numeric_argument, invalid_argument] }
    end
  end

  context "when command 'H" do
    let(:command_key) { 'H' }
    let :arguments do
      [random_numeric_argument, random_numeric_argument, random_numeric_argument, random_string_argument]
    end

    it { is_expected.to be_valid }

    it_behaves_like 'invalid argument length'
    it_behaves_like 'numeric argument' do
      let(:arguments) { [random_numeric_argument, random_numeric_argument, invalid_argument, random_string_argument] }
    end
    it_behaves_like 'string argument' do
      let(:arguments) { [random_numeric_argument, random_numeric_argument, random_numeric_argument, invalid_argument] }
    end
  end

  context "when command 'C" do
    let(:command_key) { 'C' }
    let(:arguments) { [] }

    it { is_expected.to be_valid }

    it_behaves_like 'invalid argument length' do
      let(:arguments) { [random_numeric_argument] }
    end
  end

  context "when command 'S" do
    let(:command_key) { 'S' }
    let(:arguments) { [] }

    it { is_expected.to be_valid }

    it_behaves_like 'invalid argument length' do
      let(:arguments) { [random_numeric_argument] }
    end
  end

  context 'when command not supported' do
    let(:command_key) { ['1', 'Z', '~'].sample }
    let(:arguments) { [] }

    it { is_expected.not_to be_valid }
    it { expect { command.valid? }.to change { command.errors.count }.by 1 }
  end
end
