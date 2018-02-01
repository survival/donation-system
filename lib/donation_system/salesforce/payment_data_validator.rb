# frozen_string_literal: true

require_relative '../utils'
require_relative '../validation'

module DonationSystem
  module Salesforce
    class PaymentDataValidator
      def self.execute(data)
        new(data).execute
      end

      def initialize(data)
        @data = data
      end

      def execute
        validation = Validation.new
        validation << validate_data
        validation << validate_name
        validation << validate_email
        validation << validate_amount
        validation << validate_creation_date
        validation
      end

      private

      attr_reader :data

      def validate_data
        :missing_data unless data
      end

      def validate_name
        :invalid_last_name unless data&.name
      end

      def validate_email
        :invalid_email unless data&.email
      end

      def validate_amount
        :invalid_amount unless data&.amount && utils.number?(data.amount)
      end

      def validate_creation_date
        :invalid_creation_date unless data&.created && utils.date?(data.created)
      end

      def utils
        Utils.new
      end
    end
  end
end
