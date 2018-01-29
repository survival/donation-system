# frozen_string_literal: true

require 'paypal-sdk-rest'
require_relative '../result'

module DonationSystem
  module PaypalWrapper
    class OneOff
      include PayPal::SDK::REST

      def self.charge(data)
        new(data).charge
      end

      def initialize(data)
        @data = data
        @errors = []
        config_paypal
      end

      def charge
        Result.new(execute_payment, errors)
      end

      private

      attr_reader :data, :errors

      def execute_payment
        return failure unless payment
        rescue_errors { payment.execute(payer_id: payer_id) }
        save_error(payment.error) if payment.error
        payment
      end

      def payment
        rescue_errors do
          @result ||= PayPal::SDK::REST::DataTypes::Payment.find(payment_id)
        end
        @result
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
        errors << :payment_not_found
        nil
      end

      def payment_id
        data.token.payment_id
      end

      def payer_id
        data.token.payer_id
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
