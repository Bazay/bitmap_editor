class InputParser < Struct.new(:path)
  LINE_DELIMITER = ' '

  def initialize args
    super *args
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
      raise 
      case parsed_line(line).first
      when 'S'
        puts 'There is no image'
      else
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
