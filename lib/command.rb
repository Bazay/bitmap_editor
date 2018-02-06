require_relative './mixins/error_logging'
require_relative './mixins/command_argument_validations'

class Command < Struct.new(:command, :arguments)
  include ErrorLogging
  include CommandArgumentValidations

  SUPPORTED_COMMANDS = %w[I C L V H S].freeze

  def initialize(*args)
    super
    @errors = {}
  end

  def valid?
    clear_errors
    track_base_error(:command_unsupported) unless command_supported?
    track_base_error(:invalid_arguments_count) if errors.none? && invalid_arguments_count?
    validate_arguments if errors.none?
    errors.none?
  end

  private

  def command_supported?
    SUPPORTED_COMMANDS.include? command
  end

  def track_base_error(error)
    if errors.dig :base, :messages
      errors[:base][:messages] << build_base_error_message(error)
    else
      errors[:base] = { messages: [build_base_error_message(error)] }
    end
  end

  def build_base_error_message(error)
    case error
    when :command_unsupported
      "command '#{command}' is not supported"
    when :invalid_arguments_count
      "expected #{expected_arguments_count} arguments but got #{arguments.count}"
    end
  end
end
