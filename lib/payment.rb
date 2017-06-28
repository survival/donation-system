# frozen_string_literal: true

class Payment
  Response = Struct.new(:request)

  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def process
    Response.new(request)
  end
end
