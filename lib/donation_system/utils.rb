# frozen_string_literal: true

module DonationSystem
  class Utils
    def generate_number(number_prefix)
      number_prefix + Array.new(9) { Random.rand(9) }.join
    end

    def integer?(number)
      Integer(number)
    rescue ArgumentError
      false
    end
  end
end
