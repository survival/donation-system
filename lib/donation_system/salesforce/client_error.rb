# frozen_string_literal: true

module Salesforce
  ClientError = Struct.new(:client_error) do
    def errors
      error_collection.map { |error| symbolize(error['errorCode']) }
    end

    private

    def error_collection
      return [] unless client_error && client_error.response
      client_error.response.fetch(:body, [])
    end

    def symbolize(error_code)
      error_code.downcase.to_sym
    end
  end
end
