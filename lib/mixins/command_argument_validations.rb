module CommandArgumentValidations
  ARGUMENT_NUMERIC_MINIMUM = 1
  ARGUMENT_NUMERIC_MAXIMUM = 250
  ARGUMENT_STRING_LENGTH = 1

  private

  def expected_arguments_count
    argument_types[command].count
  end

  def invalid_arguments_count?
    arguments.count != expected_arguments_count
  end

  def validate_arguments
    arguments.each_with_index do |argument, index|
      validate_argument index, argument
    end
  end

  def validate_argument(position, argument)
    argument_conditions(position).map do |key, value|
      track_argument_error(position, argument, value, key) if condition_error?(key, argument, value)
    end
  end

  def condition_error?(error, argument, value)
    condition_validators[error][:function].call argument, value
  end

  def track_argument_error(position, argument, value, error)
    if errors.dig error, :messages
      errors[error][:messages] << build_argument_error_message(position, argument, value, error)
    else
      errors[error] = { messages: [build_argument_error_message(position, argument, value, error)] }
    end
  end

  def build_argument_error_message(position, argument, value, error)
    "argument at #{position} was #{argument} but expected to be " + condition_validators[error][:message].call(value)
  end

  def argument_conditions(position)
    argument_types[command][position][:conditions]
  end

  def argument_types
    {
      'I' => [numeric_argument, numeric_argument],
      'L' => [numeric_argument, numeric_argument, string_argument],
      'V' => [numeric_argument, numeric_argument, numeric_argument, string_argument],
      'H' => [numeric_argument, numeric_argument, numeric_argument, string_argument],
      'C' => [],
      'S' => []
    }.freeze
  end

  def condition_validators
    {
      minimum: {
        function: ->(argument, value) { argument.to_i < value },
        message: ->(value) { "to be a number greater than or equal to #{value}" }
      },
      maximum: {
        function: ->(argument, value) { argument.to_i > value },
        message: ->(value) { "to be a number less than or equal to #{value}" }
      },
      length: {
        function: ->(argument, value) { argument.length != value },
        message: ->(value) { "to be a string with length equal to #{value}" }
      }
    }.freeze
  end

  def numeric_argument
    { conditions: { minimum: ARGUMENT_NUMERIC_MINIMUM, maximum: ARGUMENT_NUMERIC_MAXIMUM } }.freeze
  end

  def string_argument
    { conditions: { length: ARGUMENT_STRING_LENGTH } }.freeze
  end
end
