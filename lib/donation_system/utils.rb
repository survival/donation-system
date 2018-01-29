# frozen_string_literal: true

module DonationSystem
  class Utils
    def generate_number(number_prefix)
      number_prefix + Array.new(9) { Random.rand(9) }.join
    end
  end
end
