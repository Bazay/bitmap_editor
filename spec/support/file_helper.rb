module FileHelper
  def example_file_path
    File.join File.expand_path(File.dirname(__FILE__)), './assets/example.txt'
  end
end
