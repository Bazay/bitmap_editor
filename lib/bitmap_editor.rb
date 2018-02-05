require_relative './input_parser'

class BitmapEditor
  attr_reader :input_parser

  def initialize(path)
    @input_parser = InputParser.new path
  end

  def run
    return puts 'Please provide correct file' unless input_parser.file_present?

    load_commands
  end

  private

  def load_commands; end
end
