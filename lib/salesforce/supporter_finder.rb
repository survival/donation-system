# frozen_string_literal: true

require 'restforce'
require 'salesforce/client_error'
require 'salesforce/result'

module Salesforce
  class SupporterFinder
    ID = :Id
    SORT_FIELD = :First_entered__c

    def self.execute(field, value, client = Restforce.new)
      new(client, field, value).execute
    end

    def initialize(client, field, value)
      @client = client
      @field = field
      @value = value
      @client_errors = []
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
      search_results = search(expression)
      search_results.sort_by { |item| item[SORT_FIELD] }.first if search_results
    end

    def search(soql_expression)
      client.query(soql_expression)
    rescue Faraday::ClientError => error
      @client_errors += ClientError.new(error).errors
      nil
    end

    def expression
      "select #{ID}, #{SORT_FIELD} from #{table} where #{field}='#{value}'"
    end

    def errors
      @client_errors
    end

    def fetch(id)
      client.find(table, id)
    end
  end
end
