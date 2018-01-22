# frozen_string_literal: true

require_relative 'client_api'
require_relative '../result'
require_relative 'supporter_validator'

module DonationSystem
  module Salesforce
    class SupporterCreator
      def self.execute(data, client = ClientAPI.new)
        new(client, data).execute
      end

      def initialize(client, data)
        @client = client
        @data = data
      end

      def execute
        Result.new(supporter, errors)
      end

      private

      attr_reader :client, :data

      def table
        'Contact'
      end

      def supporter
        supporter_id = create if validation.okay?
        fetch(supporter_id) if supporter_id
      end

      def validation
        @validation ||= SupporterValidator.execute(data)
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
