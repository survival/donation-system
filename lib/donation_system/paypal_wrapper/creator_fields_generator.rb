# frozen_string_literal: true

require 'money'

require_relative '../result'
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
            description: utils.generate_number(NUMBER_PREFIX)
          }]
        }
      end

      private

      attr_reader :data

      def amount
        I18n.enforce_available_locales = false
        Money.from_amount(BigDecimal(data.amount).abs, data.currency).to_s
      end

      def currency
        data.currency.upcase
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
