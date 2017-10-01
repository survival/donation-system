# frozen_string_literal: true

require 'restforce'
require 'salesforce/client_error'
require 'salesforce/donation_validator'
require 'salesforce/result'

module Salesforce
  class DonationCreator
    def self.execute(data, supporter, client = Restforce.new)
      new(client, data, supporter).execute
    end

    def initialize(client, data, supporter)
      @client = client
      @data = data
      @supporter = supporter
      @client_errors = []
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
      fetch(donation_id) if donation_id
    end

    def donation_id
      @donation_id ||= create(validation.item) if validation.okay?
    end

    def validation
      @validation ||= DonationValidator.execute(data, supporter)
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
