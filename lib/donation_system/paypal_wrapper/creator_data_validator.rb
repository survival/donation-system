# frozen_string_literal: true

require_relative '../utils'

module DonationSystem
  class CreatorDataValidator
    def self.execute(data)
      new(data).execute
    end

    def initialize(data)
      @data = data
    end

    def execute
      validation = Validation.new
      validation << validate_data
      validation << validate_amount
      validation << validate_currency
      validation << validate_return_url
      validation << validate_cancel_url
      validation
    end

    private

    attr_reader :data

    def validate_data
      :missing_data unless data
    end

    def validate_amount
      :invalid_amount unless data&.amount && utils.number?(data.amount) &&
                             utils.number(data.amount).positive?
    end

    def validate_currency
      :invalid_currency unless data&.currency && utils.currency?(data.currency)
    end

    def validate_return_url
      :invalid_return_url unless data&.return_url && utils.url?(data.return_url)
    end

    def validate_cancel_url
      :invalid_cancel_url unless data&.cancel_url && utils.url?(data.cancel_url)
    end

    def utils
      Utils.new
    end

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
  end
end
