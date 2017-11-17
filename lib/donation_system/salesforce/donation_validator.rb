# frozen_string_literal: true

require 'date'
require 'money'
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
        required_data
          .merge(card_data)
          .merge(extra_fields)
      end

      def required_data
        {
          Amount: amount_in_currency_units,
          CloseDate: format_time(data.payment_data.created),
          Name: 'Online donation',
          StageName: 'Received',
          AccountId: supporter[:AccountId]
        }
      end

      def card_data
        {
          CurrencyIsoCode: data.payment_data.currency&.upcase,
          Last_digits__c: data.payment_data.source&.last4,
          Card_type__c: data.payment_data.source&.brand,
          Gateway_transaction_ID__c: data.payment_data.id,
          Receiving_Organization__c: 'Survival UK',
          Payment_method__c: 'Card (Stripe)',
          RecordTypeId: '01280000000Fvqi'
        }
      end

      def extra_fields
        {
          IsPrivate: false,
          Gift_Aid__c: data.request_data.giftaid,
          Block_Gift_Aid_Reclaim__c: false,
          Fundraising__c: false
        }
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

      def format_time(seconds_since_epoch)
        Time.at(seconds_since_epoch).strftime('%Y-%m-%d')
      end

      def integer?(number)
        Integer(number)
      rescue ArgumentError
        false
      end

      def amount_in_currency_units
        I18n.enforce_available_locales = false
        Money.new(data.payment_data.amount, data.payment_data.currency).to_s
      end
    end
  end
end
