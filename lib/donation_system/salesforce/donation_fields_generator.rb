# frozen_string_literal: true

require_relative '../utils'

module DonationSystem
  module Salesforce
    class DonationFieldsGenerator
      ONEOFF_TABLE = 'Opportunity'
      RECURRING_TABLE = 'Regular_Donation__c'

      NAME = 'Online donation'
      SURVIVAL_UK = 'Survival UK'
      RECEIVED = 'Received'
      DECLINED = 'Declined'

      def self.execute(data, supporter)
        new(data, supporter).execute
      end

      def initialize(data, supporter)
        @data = data
        @supporter = supporter
      end

      def execute
        return TableAndFields.new(ONEOFF_TABLE, for_oneoff) if data.oneoff?
        TableAndFields.new(RECURRING_TABLE, for_recurring)
      end

      private

      attr_reader :data, :supporter

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

      def required_data
        {
          Amount: amount_in_currency_units,
          CloseDate: format_time(data.created),
          Name: NAME,
          StageName: stage_name,
          AccountId: supporter[:AccountId]
        }
      end

      def card_data
        {
          CurrencyIsoCode: data.currency.upcase,
          Last_digits__c: data.last4,
          Card_type__c: data.brand,
          Receiving_Organization__c: SURVIVAL_UK,
          Payment_method__c: data.method,
          RecordTypeId: data.record_type_id
        }
      end

      def extra_fields
        {
          IsPrivate: false,
          Gift_Aid__c: data.giftaid,
          Block_Gift_Aid_Reclaim__c: false,
          Fundraising__c: false,
          Gateway_transaction_ID__c: data.id,
          Web_Payment_Number__c: data.number
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
          Card_Expiry_Month__c: data.expiry_month,
          Card_Expiry_Year__c: data.expiry_year
        }
      end

      def recurring_specific_data
        {
          Gateway_mandate_ID__c: data.id,
          Web_Mandate_Number__c: data.number,
          Start_Date__c: format_time(data.start_date),
          DD_Mandate_Reference__c: data.reference,
          Collection_day__c: data.collection_day,
          DD_Method__c: data.mandate_method,
          Account_Holder_Name__c: data.account_holder_name
        }
      end

      def stage_name
        data.received? ? RECEIVED : DECLINED
      end

      def amount_in_currency_units
        utils.amount_in_currency_units(data)
      end

      def format_time(seconds_since_epoch)
        utils.format_time(seconds_since_epoch)
      end

      def utils
        Utils.new
      end

      TableAndFields = Struct.new(:table, :fields)
    end
  end
end
