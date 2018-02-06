module ErrorLogging
  attr_accessor :errors

  private

  def clear_errors
    @errors = {}
  end
end
