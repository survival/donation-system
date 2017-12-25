# frozen_string_literal: true

module DonationSystem
  Result = Struct.new(:item, :errors) do
    def okay?
      errors.empty?
    end

    def errors?
      !okay?
    end
  end
end
