require_relative './input_parser'
require_relative './mixins/error_logging'

class BitmapEditor
  attr_reader :input_parser
  attr_accessor :commands

  include ErrorLogging

  def initialize(file_path)
    @input_parser = InputParser.new file_path
    @commands = []
    @image_grid = []
  end

  def run
    return puts 'Please provide correct file' unless input_parser.file_present?

    load_commands
    execute_commands
  end

  private

  def load_commands
    commands = input_parser.parse
  end

  def execute_commands
    commands.each_with_index do |command, line|
      # Do magical things
    end
  end

  def build_image_grid(width, height); end
end
