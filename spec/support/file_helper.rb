module FileHelper
  def example_file_path
    File.join File.expand_path(__dir__), './assets/example.txt'
  end

  def array_to_file(lines)
    Tempfile.new('temp-file-').tap do |file|
      lines.each { |line| file.puts(line) }
      file.close
    end
  end
end
