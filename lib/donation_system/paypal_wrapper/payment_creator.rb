# frozen_string_literal: true

require 'paypal-sdk-rest'

require_relative 'creator_data_validator'
require_relative 'creator_fields_generator'
require_relative '../result'

module DonationSystem
  module PaypalWrapper
    class PaymentCreator
      include PayPal::SDK::REST

      def self.execute(data)
        new(data).execute
      end

      def initialize(data)
        @data = data
        @errors = []
        config_paypal
      end

      def execute
        Result.new(payment, errors)
      end

      private

      attr_reader :data, :errors

      def payment
        return failure unless validation.okay?
        payment = PayPal::SDK::REST::DataTypes::Payment.new(fields)
        rescue_errors { payment.create }
        save_error(payment.error) if payment.error
        payment
      end

      def rescue_errors
        yield
      rescue PayPal::SDK::Core::Exceptions::UnauthorizedAccess
        errors << :unauthorized_access
      rescue PayPal::SDK::Core::Exceptions::ServerError
        errors << :internal_server_error
      rescue StandardError
        errors << :unknown_error
      end

      def save_error(error)
        errors << error.name.downcase.to_sym
      end

      def failure
        @errors += validation.errors
        nil
      end

      def validation
        @validation ||= CreatorDataValidator.execute(data)
      end

      def fields
        CreatorFieldsGenerator.execute(data)
      end

      def config_paypal
        PayPal::SDK::REST.set_config(
          mode: ENV['PAYPAL_MODE'],
          client_id: ENV['PAYPAL_CLIENT_ID'],
          client_secret: ENV['PAYPAL_CLIENT_SECRET'],
          ssl_options: {}
        )
      end
    end
  end
end
