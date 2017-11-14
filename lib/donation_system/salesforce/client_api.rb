# frozen_string_literal: true

require 'restforce'
require_relative 'client_error'
require_relative 'result'

module DonationSystem
  module Salesforce
    class ClientAPI
      attr_reader :errors

      def initialize(client = Restforce.new)
        @client = client
        @errors = []
      end

      def search(soql_expression)
        client.query(soql_expression)
      rescue Faraday::ClientError => error
        save_client_error(error)
        nil
      end

      def create(table, sobject_fields)
        client.create!(table, sobject_fields)
      rescue Faraday::ClientError => error
        save_client_error(error)
        nil
      end

      def fetch(table, id)
        client.find(table, id)
      end

      private

      attr_reader :client

      def save_client_error(error)
        @errors += ClientError.new(error).errors
      end
    end
  end
end
