# frozen_string_literal: true

require_relative 'client_api'
require_relative '../result'
require_relative 'supporter_fields_generator'

module DonationSystem
  module Salesforce
    class SupporterCreator
      TABLE = 'Contact'

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

      def supporter
        supporter_id = create
        fetch(supporter_id) if supporter_id
      end

      def fields
        SupporterFieldsGenerator.execute(data)
      end

      def create
        client.create(TABLE, fields)
      end

      def fetch(id)
        client.fetch(TABLE, id)
      end

      def errors
        client.errors
      end
    end
  end
end
