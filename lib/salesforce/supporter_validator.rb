# frozen_string_literal: true

require 'salesforce/result'

module Salesforce
  class SupporterValidator
    def self.execute(data)
      new(data).execute
    end

    def initialize(data)
      @data = data
    end

    def execute
      Result.new(fields, errors)
    end

    private

    attr_reader :data

    def fields
      return unless errors.empty?
      {
        LastName: data.name,
        Email: data.email
      }
    end

    def errors
      validation_errors = []
      validation_errors << :missing_data unless data
      validation_errors << :invalid_last_name unless data && data.name
      validation_errors << :invalid_email unless data && data.email
      validation_errors.compact
    end
  end
end
