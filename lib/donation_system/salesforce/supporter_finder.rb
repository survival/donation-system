# frozen_string_literal: true

require_relative 'client_api'

module DonationSystem
  module Salesforce
    class SupporterFinder
      ID = :Id
      SORT_FIELD = :First_entered__c

      def self.execute(field, value, client = ClientAPI.new)
        new(client, field, value).execute
      end

      def initialize(client, field, value)
        @client = client
        @field = field
        @value = value
      end

      def execute
        Result.new(supporter, errors)
      end

      private

      attr_reader :client, :field, :value

      def table
        'Contact'
      end

      def supporter
        first = first_entered
        fetch(first[ID]) if first
      end

      def first_entered
        sorted = search.sort_by { |item| item[SORT_FIELD] }
        sorted.first
      end

      def expression
        "select #{ID}, #{SORT_FIELD} from #{table} where #{field}='#{value}'"
      end

      def search
        @search ||= client.search(expression) || []
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
