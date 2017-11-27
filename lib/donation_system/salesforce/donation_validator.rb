# frozen_string_literal: true

require_relative 'result'

module DonationSystem
  module Salesforce
    class DonationValidator
      def self.execute(data, supporter)
        new(data, supporter).execute
      end

      def initialize(data, supporter)
        @data = data
        @supporter = supporter
      end

      def execute
        Result.new(fields, errors)
      end

      private

      attr_reader :data, :supporter

      def fields
        return unless errors.empty?
        {
          Amount: data.payment_data.amount.to_s,
          CloseDate: '2017-09-11',
          Name: 'Online donation',
          StageName: 'Received',
          AccountId: supporter[:AccountId]
        }
      end

      def errors
        validation_errors = []
        validation_errors << validate_data
        validation_errors << validate_amount
        validation_errors << validate_account_id
        validation_errors.compact
      end

      def validate_data
        :missing_data unless data
      end

      def validate_amount
        :invalid_amount unless data&.payment_data&.amount && integer_amount?
      end

      def validate_account_id
        :invalid_account_id unless supporter && supporter[:AccountId]
      end

      def integer_amount?
        Integer(data.payment_data.amount)
      rescue ArgumentError
        false
      end
    end
  end
end
