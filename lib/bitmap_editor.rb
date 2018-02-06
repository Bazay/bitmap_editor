require_relative './input_parser'
require_relative './mixins/error_logging'
require 'pry'

class BitmapEditor
  attr_reader :input_parser, :commands, :image_grid

  DEFAULT_BLOCK_COLOUR = 'O'.freeze

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

  def image_width
    image_grid.first.size
  end

  def image_height
    image_grid.size
  end

  private

  def load_commands
    @commands = input_parser.parse
  end

  def execute_commands
    commands.each { |command| run_command(command) if command&.valid? }
  end

  def run_command(command)
    case command.command_key
    when 'I' then build_image_grid(*command.parsed_arguments)
    when 'L' then colour_pixel(*command.parsed_arguments)
    when 'V' then colour_vertical_pixels(*command.parsed_arguments)
    when 'H' then colour_horizontal_pixels(*command.parsed_arguments)
    when 'C' then clear_image_grid
    when 'S' then show_image_grid
    end
  end

  def build_image_grid(width, height)
    @image_grid = Array.new(height) { Array.new(width, DEFAULT_BLOCK_COLOUR) }
  end

  def colour_pixel(x, y, colour)
    return if @image_grid.nil?
    return unless in_bounds?(x: x, y: y)
    x_index = coordinate_to_array_index(x, image_width)
    y_index = coordinate_to_array_index(y, image_height)
    @image_grid[y_index][x_index] = colour
  end

  def colour_vertical_pixels(x, y1, y2, colour)
    return if @image_grid.nil?
    return unless in_bounds?(x: x, y: y1, y2: y2)
    x_index = coordinate_to_array_index(x, image_width)
    for y in y1..y2
      y_index = coordinate_to_array_index(y, image_height)
      @image_grid[y_index][x_index] = colour
    end
  end

  def colour_horizontal_pixels(x1, x2, y, colour)
    return if @image_grid.nil?
    return unless in_bounds?(x: x1, x2: x2, y: y)
    y_index = coordinate_to_array_index(y, image_height)
    for x in x1..x2
      x_index = coordinate_to_array_index(x, image_width)
      @image_grid[y_index][x_index] = colour
    end
  end

  def clear_image_grid
    return if @image_grid.nil?
    @image_grid = Array.new(image_height) { Array.new(image_width, DEFAULT_BLOCK_COLOUR) }
  end

  def show_image_grid
    return puts("There's no image to show") if @image_grid.nil?
    puts @image_grid.map { |row| row.join }.join("\n")
  end

  def in_bounds?(x:, y:, x2: nil, y2: nil)
    if x2
      (x <= image_width || x2 <= image_width) && y <= image_height
    elsif y2
      x <= image_width && (y <= image_height || y2 <= image_height)
    else
      x <= image_width && y <= image_height
    end
  end

  def coordinate_to_array_index(coordinate, limit)
    (coordinate > limit ? limit : coordinate) - 1
  end
end
