# frozen_string_literal: true

require 'stripe'
require 'stripe/input_data_validator'
require 'stripe/result'

module Stripe
  class Gateway
    def self.charge(data)
      new(data).charge
    end

    def initialize(data)
      @data = data
      @api_errors = []
    end

    def charge
      Result.new(charge_result, errors)
    end

    private

    attr_reader :data, :api_errors

    def charge_result
      charge_and_rescue_data_related_errors
    rescue Stripe::RateLimitError
      save_error(:too_many_requests)
    rescue Stripe::APIConnectionError
      save_error(:connection_problems)
    rescue Stripe::StripeError
      save_error(:stripe_error)
    rescue StandardError
      save_error(:unknown_error)
    end

    def charge_and_rescue_data_related_errors
      create_stripe_charge
    rescue Stripe::AuthenticationError
      save_error(:invalid_api_key)
    rescue Stripe::InvalidRequestError
      save_error(:invalid_parameter)
    rescue Stripe::CardError
      save_error(:declined_card)
    rescue Stripe::APIError
      save_error(:invalid_response_object)
    end

    def create_stripe_charge
      Stripe.api_key = ENV['STRIPE_API_KEY']
      Stripe::Charge.create(input_data)
    end

    def input_data
      validation.item if validation.okay?
    end

    def validation
      @validation ||= InputDataValidator.execute(data)
    end

    def save_error(error_code)
      @api_errors << error_code
      nil
    end

    def errors
      validation.errors + api_errors
    end
  end
end
