# frozen_string_literal: true

class Validation
  attr_reader :errors

  def initialize
    @errors = []
  end

  def <<(error)
    errors << error if error
  end

  def okay?
    errors.empty?
  end
end
