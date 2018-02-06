require_relative './command'

class InputParser
  attr_reader :file_path

  COMMAND_DELIMITER = ' '.freeze

  def initialize file_path
    @file_path = file_path
  end

  def file_present?
    !file_path.empty? && file_exists?
  end

  def parse
    return unless file_present?

    File.open(file_path).each_with_index.map do |line, index|
      command_key, argument_string = line.chomp.split(COMMAND_DELIMITER, 2)
      command_key.to_s.empty? ? nil : build_command(command_key, argument_string)
    end
  end

  def errors
    @errors ||= []
  end

  private

  def file_exists?
    File.exist?(file_path)
  end

  def build_command(command_key, argument_string)
    arguments = argument_string&.split(COMMAND_DELIMITER) || []
    Command.new(command_key, arguments)
  end
end
