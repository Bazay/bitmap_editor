class InputParser < Struct.new(:path)
  LINE_DELIMITER = ' '.freeze

  def initialize(*args)
    super
    @file = nil
    @commands = []
  end

  def file_present?
    !path.empty? && file_exists?
  end

  def parse!
    # Do sum tings
    File.open(file_path).each_with_index do |line, index|
      line = line.chomp.split LINE_DELIMITER
      case parsed_line(line).first
      when 'S'
        puts 'There is no image'
      end
    end
  end

  def errors
    @errors ||= []
  end

  private

  def file_exists?
    File.exist? path
  end
end
