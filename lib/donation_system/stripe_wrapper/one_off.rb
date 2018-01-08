# frozen_string_literal: true

require 'stripe'

require_relative 'fields_generator'
require_relative 'resource_creator'

module DonationSystem
  module StripeWrapper
    class OneOff
      def self.charge(data)
        new(data).charge
      end

      def initialize(data)
        @data = data
      end

      def charge
        ResourceCreator.create(Stripe::Charge, fields_generator.for_charge)
      end

      private

      attr_reader :data

      def fields_generator
        FieldsGenerator.new(data)
      end
    end
  end
end
