require_relative './input_parser'
require_relative './mixins/error_logging'

class BitmapEditor
  attr_reader :input_parser, :image_grid
  attr_accessor :commands

  DEFAULT_BLOCK_COLOUR = '0'.freeze

  include ErrorLogging

  def initialize(input_file_path)
    @input_parser = InputParser.new input_file_path
    @commands = []
    @image_grid = []
  end

  def run
    return puts "No file found at `#{input_parser.file_path}`" unless input_parser.file_present?

    load_commands
    execute_commands
  end

  private

  def load_commands
    self.commands = input_parser.parse
  end

  def execute_commands
    commands.each_with_index do |command, line|      
      command.valid? ? run_command(command) : log_invalid_command(command)
    end
  end

  def run_command(command)
    case command.command_key
    when 'I' then build_image_grid(*command.parsed_arguments)
    end
  end

  def build_image_grid(width, height)
    @image_grid = Array.new(width, Array.new(height, DEFAULT_BLOCK_COLOUR))
  end

  def log_invalid_command(command); end
end
