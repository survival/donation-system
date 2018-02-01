# frozen_string_literal: true

require_relative 'client_api'
require_relative 'donation_fields_generator'
require_relative '../result'

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

      def donation
        donation_id = create
        fetch(donation_id) if donation_id
      end

      def table
        fields_generator.table
      end

      def fields
        fields_generator.fields
      end

      def fields_generator
        @fields_generator ||= DonationFieldsGenerator.execute(data, supporter)
      end

      def create
        client.create(table, fields)
      end

      def fetch(id)
        client.fetch(table, id)
      end

      def errors
        client.errors
      end
    end
  end
end
