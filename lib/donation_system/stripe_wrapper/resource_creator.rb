# frozen_string_literal: true

require 'stripe'
require_relative '../result'

module DonationSystem
  module StripeWrapper
    class ResourceCreator
      def self.create(resource, fields)
        new(resource, fields).create
      end

      def initialize(resource, fields)
        @resource = resource
        @fields = fields
        @errors = []
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      end

      def create
        Result.new(creation_result, errors)
      end

      private

      attr_reader :resource, :fields, :errors

      def creation_result
        rescue_net_errors { rescue_data_errors { create_resource } }
      end

      def rescue_net_errors
        yield
      rescue Stripe::RateLimitError
        save_error(:too_many_requests)
      rescue Stripe::APIConnectionError
        save_error(:connection_problems)
      rescue Stripe::StripeError
        save_error(:stripe_error)
      rescue StandardError
        save_error(:unknown_error)
      end

      def rescue_data_errors
        yield
      rescue Stripe::AuthenticationError
        save_error(:invalid_api_key)
      rescue Stripe::InvalidRequestError
        save_error(:invalid_parameter)
      rescue Stripe::CardError
        save_error(:declined_card)
      rescue Stripe::APIError
        save_error(:invalid_response_object)
      end

      def create_resource
        resource.create(fields)
      end

      def save_error(error_code)
        @errors << error_code
        nil
      end
    end
  end
end
