# frozen_string_literal: true

require 'date'
require 'money'

require_relative '../result'
require_relative 'donation_fields_generator'

module DonationSystem
  module Salesforce
    class DonationValidator
      ONEOFF_TABLE = 'Opportunity'
      RECURRING_TABLE = 'Regular_Donation__c'

      def self.execute(data, supporter)
        new(data, supporter).execute
      end

      def initialize(data, supporter)
        @data = data
        @supporter = supporter
      end

      def execute
        Result.new(item, errors)
      end

      private

      attr_reader :data, :supporter

      def item
        return unless errors.empty?
        return item_for_oneoff if payment_data.oneoff?
        item_for_recurring
      end

      def errors
        validation_errors = []
        validation_errors << validate_data
        validation_errors << validate_request_data
        validation_errors << validate_payment_data
        validation_errors << validate_amount
        validation_errors << validate_creation_date
        validation_errors << validate_account_id
        validation_errors.compact
      end

      def validate_data
        :missing_data unless data
      end

      def validate_request_data
        :missing_request_data unless data&.request_data
      end

      def validate_payment_data
        :missing_payment_data unless data&.payment_data
      end

      def validate_amount
        :invalid_amount unless data&.payment_data&.amount &&
                               integer?(data.payment_data.amount)
      end

      def validate_creation_date
        :invalid_creation_date unless data&.payment_data&.created &&
                                      integer?(data.payment_data.created)
      end

      def validate_account_id
        :invalid_account_id unless supporter && supporter[:AccountId]
      end

      def integer?(number)
        Integer(number)
      rescue ArgumentError
        false
      end

      def request_data
        data.request_data
      end

      def payment_data
        data.payment_data
      end

      def item_for_oneoff
        TableAndFields.new(ONEOFF_TABLE, fields_generator.for_oneoff)
      end

      def item_for_recurring
        TableAndFields.new(RECURRING_TABLE, fields_generator.for_recurring)
      end

      def fields_generator
        DonationFieldsGenerator.new(request_data, payment_data, supporter)
      end

      TableAndFields = Struct.new(:table, :fields)
    end
  end
end
