# frozen_string_literal: true

require_relative '../utils'

module DonationSystem
  module PaypalWrapper
    class CreatorFieldsGenerator
      INTENT = 'sale'
      PAYPAL_METHOD = 'paypal'
      NUMBER_PREFIX = 'P'

      def self.execute(data)
        new(data).execute
      end

      def initialize(data)
        @data = data
      end

      def execute
        {
          intent: INTENT,
          payer: { payment_method: PAYPAL_METHOD },
          redirect_urls: redirect_urls,
          transactions: [{
            amount: { total: amount, currency: currency },
            description: payment_number
          }]
        }
      end

      private

      attr_reader :data

      def amount
        utils.amount_in_currency_units(data.amount, currency)
      end

      def currency
        utils.currency_in_uppercase(data.currency)
      end

      def payment_number
        utils.generate_number(NUMBER_PREFIX)
      end

      def redirect_urls
        {
          return_url: data.return_url,
          cancel_url: data.cancel_url
        }
      end

      def utils
        Utils.new
      end
    end
  end
end
