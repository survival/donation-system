# frozen_string_literal: true

require 'restforce'
require 'salesforce/client_error'
require 'salesforce/result'
require 'salesforce/supporter_validator'

module Salesforce
  class SupporterCreator
    def self.execute(data, client = Restforce.new)
      new(client, data).execute
    end

    def initialize(client, data)
      @client = client
      @data = data
      @client_errors = []
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
      fetch(supporter_id) if supporter_id
    end

    def supporter_id
      @supporter_id ||= create(validation.item) if validation.okay?
    end

    def validation
      @validation ||= SupporterValidator.execute(data)
    end

    def create(sobject_fields)
      client.create!(table, sobject_fields)
    rescue Faraday::ClientError => error
      @client_errors += ClientError.new(error).errors
      nil
    end

    def errors
      validation.errors + @client_errors
    end

    def fetch(id)
      client.find(table, id)
    end
  end
end
