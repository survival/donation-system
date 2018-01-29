# frozen_string_literal: true

require_relative 'adapters/paypal_one_off_salesforce'
require_relative 'adapters/stripe_one_off_salesforce'
require_relative 'adapters/stripe_recurring_salesforce'
require_relative 'paypal_wrapper/one_off'
require_relative 'stripe_wrapper/one_off'
require_relative 'stripe_wrapper/recurring'

module DonationSystem
  module Selector
    SELECTOR = {
      stripe_one_off: {
        gateway: StripeWrapper::OneOff,
        adapter: Adapters::StripeOneOffSalesforce
      },
      stripe_recurring: {
        gateway: StripeWrapper::Recurring,
        adapter: Adapters::StripeRecurringSalesforce
      },
      paypal_one_off: {
        gateway: PaypalWrapper::OneOff,
        adapter: Adapters::PaypalOneOffSalesforce
      }
    }.freeze

    def self.select_gateway(data)
      select_group(data)&.fetch(:gateway)
    end

    def self.select_adapter(data)
      select_group(data)&.fetch(:adapter)
    end

    def self.select_group(data)
      selection_key = "#{data.method}_#{data.type.tr('-', '_')}".to_sym
      SELECTOR.fetch(selection_key, nil)
    end
  end
end
