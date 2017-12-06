# frozen_string_literal: true

require 'date'
require_relative 'result'

module DonationSystem
  module Salesforce
    class SupporterValidator
      def self.execute(data)
        new(data).execute
      end

      def initialize(data)
        @data = data
      end

      def execute
        Result.new(fields, errors)
      end

      private

      attr_reader :data

      def fields
        return unless errors.empty?
        required_data
          .merge(mailing_data)
          .merge(extra_fields)
      end

      def required_data
        {
          LastName: data.request_data.name,
          Email: data.request_data.email,
          First_entered__c: Date.today
        }
      end

      def mailing_data
        {
          MailingStreet: data.request_data.address,
          MailingCity: data.request_data.city,
          MailingState: data.request_data.state,
          MailingPostalCode: data.request_data.zip,
          MailingCountry: data.request_data.country
        }
      end

      def extra_fields
        {
          Greeting__c: 'Hi',
          npe01__Private__c: false,
          npe01__SystemIsIndividual__c: true,
          Do_not_email__c: false,
          Couple__c: false,
          Deceased__c: false
        }
      end

      def errors
        validation_errors = []
        validation_errors << validate_data
        validation_errors << validate_name
        validation_errors << validate_email
        validation_errors.compact
      end

      def validate_data
        :missing_data unless data
      end

      def validate_name
        :invalid_last_name unless data&.request_data&.name
      end

      def validate_email
        :invalid_email unless data&.request_data&.email
      end
    end
  end
end
