# frozen_string_literal: true

require 'stripe'

require_relative 'fields_generator'
require_relative 'resource_creator'

module DonationSystem
  module StripeWrapper
    class Recurring
      def self.charge(data)
        new(data).charge
      end

      def initialize(data)
        @data = data
      end

      def charge
        return plan unless plan.okay?
        return customer unless customer.okay?
        subscription
      end

      private

      attr_reader :data

      def plan
        @plan ||= ResourceCreator.create(
          Stripe::Plan, fields_generator.for_plan
        )
      end

      def customer
        @customer ||= ResourceCreator.create(
          Stripe::Customer, fields_generator.for_customer
        )
      end

      def subscription
        ResourceCreator.create(
          Stripe::Subscription,
          fields_generator.for_subscription(plan.item, customer.item)
        )
      end

      def fields_generator
        @fields_generator ||= FieldsGenerator.new(data)
      end
    end
  end
end
