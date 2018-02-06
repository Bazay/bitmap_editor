require_relative './input_parser'
require_relative './mixins/error_logging'

class BitmapEditor
  attr_reader :input_parser, :commands, :image_grid

  DEFAULT_BLOCK_COLOUR = '0'.freeze

  include ErrorLogging

  def initialize(input_file_path)
    @input_parser = InputParser.new input_file_path
    @commands = []
    @image_grid = nil
  end

  def run
    return puts "No file found at `#{input_parser.file_path}`" unless input_parser.file_present?

    load_commands
    execute_commands
  end

  private

  def load_commands
    @commands = input_parser.parse
  end

  def execute_commands
    commands.each_with_index do |command, line|      
      command.valid? ? run_command(command) : log_invalid_command(command)
    end
  end

  def run_command(command)
    case command.command_key
    when 'I' then build_image_grid(*command.parsed_arguments)
    when 'L' then colour_pixel(*command.parsed_arguments)
    end
  end

  def build_image_grid(width, height)
    @image_grid = Array.new(height) { Array.new(width, DEFAULT_BLOCK_COLOUR) }
  end

  def colour_pixel(x, y, colour)
    x_index = coordinate_to_array_index(x)
    y_index = coordinate_to_array_index(y)
    @image_grid[y_index][x_index] = colour
  end

  def coordinate_to_array_index(coordinate)
    coordinate -= 1
  end

  def log_invalid_command(command); end
end
