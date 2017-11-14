# frozen_string_literal: true

require_relative 'client_api'
require_relative 'donation_validator'

module DonationSystem
  module Salesforce
    class DonationCreator
      def self.execute(data, supporter, client = ClientAPI.new)
        new(client, data, supporter).execute
      end

      def initialize(client, data, supporter)
        @client = client
        @data = data
        @supporter = supporter
      end

      def execute
        Result.new(donation, errors)
      end

      private

      attr_reader :client, :data, :supporter

      def table
        'Opportunity'
      end

      def donation
        donation_id = create if validation.okay?
        fetch(donation_id) if donation_id
      end

      def validation
        @validation ||= DonationValidator.execute(data, supporter)
      end

      def fields
        validation.item
      end

      def create
        client.create(table, fields)
      end

      def fetch(id)
        client.fetch(table, id)
      end

      def errors
        validation.errors + client.errors
      end
    end
  end
end
