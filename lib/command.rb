class Command < Struct.new(:command, :arguments)
  attr_reader :errors

  SUPPORTED_COMMANDS = %w[I C L V H S].freeze
  ARGUMENT_TYPES = {
    'I' => [integer_argument, integer_argument],
    'L' => [integer_argument, integer_argument, string_argument],
    'V' => [integer_argument, integer_argument, integer_argument, string_argument],
    'H' => [integer_argument, integer_argument, integer_argument, string_argument],
    'C' => [],
    'S' => []
  }.freeze
  SUPPORTED_COLOURS = %w[RED GREEN BLUE WHITE BLACK YELLOW ORANGE PURPLE GRAY BROWN].freeze


  class << self
    def integer_argument
      { klass: 'Integer', conditions: { minimum: 1, maximum: 250 } }
    end

    def string_argument
      { klass: 'String', conditions: { included_in: SUPPORTED_COLOURS } }
    end
  end

  def initialize *args
    super
    @errors = []
  end

  def valid?
    clear_errors
    errors << 'unrecognised command :(' unless command_supported?
    errors << "argument error, expected #{expected_arguments_count} but got #{arguments.count}" if command_supported? && invalid_arguments_count?
    validate_arguments
    errors.none?
  end

  private

    def clear_errors
      @errors = []
    end

    def command_supported?
      SUPPORTED_COMMANDS.include? command
    end

    def invalid_arguments_count?
      arguments.count != expected_arguments_count
    end

    def expected_arguments_count
      case command
      when 'I' then 2
      when 'L' then 3
      when 'V', 'H' then 4
      when 'C', 'S' then 0
      end
    end

    def validate_arguments
      arguments.each_with_index do |argument, index|
        expected_klass = ARGUMENT_TYPES[command][index][:klass]
        errors << "argument error, expected argument at #{index} to be #{expected_klass} but got #{argument.class.name}" unless valid_argument_klass?(argument) && break
        validate_argument argument, index
      end
    end

    def valid_argument_class? argument
      argument.class.name == expected_klass
    end

    def validate_argument argument, index
      case argument.class.name
      when 'Integer'
        errors << '' if argument.to_i >= ARGUMENT_TYPES[command][index][:conditions][:minimum] && argument.to_i <= ARGUMENT_TYPES[command][index][:conditions][:maximum]
      when 'String'
    end
end
