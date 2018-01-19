# frozen_string_literal: true

require 'date'
require 'money'

module DonationSystem
  module Salesforce
    class DonationFieldsGenerator
      NAME = 'Online donation'
      SURVIVAL_UK = 'Survival UK'
      TIME_FORMAT = '%Y-%m-%d'
      RECEIVED = 'Received'
      DECLINED = 'Declined'

      def initialize(request_data, payment_data, supporter)
        @request_data = request_data
        @payment_data = payment_data
        @supporter = supporter
      end

      def for_oneoff
        required_data
          .merge(card_data)
          .merge(extra_fields)
      end

      def for_recurring
        recurring_required_data
          .merge(card_data)
          .merge(extra_card_data)
          .merge(recurring_specific_data)
      end

      private

      attr_reader :request_data, :payment_data, :supporter

      def required_data
        {
          Amount: amount_in_currency_units,
          CloseDate: format_time(payment_data.created),
          Name: NAME,
          StageName: stage_name,
          AccountId: supporter[:AccountId]
        }
      end

      def card_data
        {
          CurrencyIsoCode: payment_data.currency.upcase,
          Last_digits__c: payment_data.last4,
          Card_type__c: payment_data.brand,
          Receiving_Organization__c: SURVIVAL_UK,
          Payment_method__c: payment_data.method,
          RecordTypeId: payment_data.record_type_id
        }
      end

      def extra_fields
        {
          IsPrivate: false,
          Gift_Aid__c: request_data.giftaid,
          Block_Gift_Aid_Reclaim__c: false,
          Fundraising__c: false,
          Gateway_transaction_ID__c: payment_data.id,
          Web_Payment_Number__c: payment_data.number
        }
      end

      def recurring_required_data
        {
          Contact__c: supporter[:Id],
          Amount__c: amount_in_currency_units
        }
      end

      def extra_card_data
        {
          Card_Expiry_Month__c: payment_data.expiry_month,
          Card_Expiry_Year__c: payment_data.expiry_year
        }
      end

      def recurring_specific_data
        {
          Gateway_mandate_ID__c: payment_data.id,
          Web_Mandate_Number__c: payment_data.number,
          Start_Date__c: format_time(payment_data.start_date),
          DD_Mandate_Reference__c: payment_data.reference,
          Collection_day__c: payment_data.collection_day,
          DD_Method__c: payment_data.mandate_method,
          Account_Holder_Name__c: payment_data.account_holder_name
        }
      end

      def format_time(seconds_since_epoch)
        Time.at(seconds_since_epoch).strftime(TIME_FORMAT)
      end

      def stage_name
        payment_data.received? ? RECEIVED : DECLINED
      end

      def amount_in_currency_units
        I18n.enforce_available_locales = false
        Money.new(payment_data.amount, payment_data.currency).to_s
      end
    end
  end
end
