# frozen_string_literal: true

require 'donation_system/payment_gateway'
require 'spec_helper'

module DonationSystem
  RSpec.describe PaymentGateway do
    it 'delegates to Stripe' do
      result = Result.new('irrelevant', [])
      expect(StripeWrapper::Gateway).to receive(:charge).and_return(result)
      expect(described_class.charge('irrelevant')).to be_okay
    end
  end
end
