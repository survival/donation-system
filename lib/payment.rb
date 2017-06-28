# frozen_string_literal: true

class Payment
  attr_accessor :request

  def initialize(request)
    @request = request
  end
end
