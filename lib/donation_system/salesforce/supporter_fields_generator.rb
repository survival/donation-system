# frozen_string_literal: true

require 'date'

module DonationSystem
  module Salesforce
    class SupporterFieldsGenerator
      def self.execute(data)
        new(data).execute
      end

      def initialize(data)
        @data = data
      end

      def execute
        required_data
          .merge(mailing_data)
          .merge(extra_fields)
      end

      private

      attr_reader :data

      def required_data
        {
          LastName: data.name,
          Email: data.email,
          First_entered__c: Date.today
        }
      end

      def mailing_data
        {
          MailingStreet: data.address,
          MailingCity: data.city,
          MailingState: data.state,
          MailingPostalCode: data.zip,
          MailingCountry: data.country
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
    end
  end
end
