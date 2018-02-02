# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/payment_gateway'
require 'spec_helper'

module DonationSystem
  RSpec.describe PaymentGateway do
    let(:data) { VALID_REQUEST_DATA.dup }

    it 'has errors if validation fails' do
      data.type = 'invalid type'
      expect(described_class.charge(data).item).to be_nil
      expect(described_class.charge(data)).not_to be_okay
    end

    describe 'when donation is one-off' do
      before { data.type = InputDataValidator::VALID_TYPES[:oneoff] }

      it 'uses a one-off gateway' do
        result = Result.new(VALID_STRIPE_CHARGE, [])
        expect(StripeWrapper::OneOff).to receive(:charge).and_return(result)
        described_class.charge(data)
      end

      it 'returns no errors when payment is OK' do
        result = Result.new('irrelevant', [])
        expect(StripeWrapper::OneOff).to receive(:charge).and_return(result)
        expect(described_class.charge(data)).to be_okay
      end

      it 'has errors if payment fails' do
        bad_result = Result.new(nil, [:error])
        allow(StripeWrapper::OneOff).to receive(:charge).and_return(bad_result)
        expect(described_class.charge(data).errors).to include(:error)
      end
    end

    describe 'when donation is recurring' do
      before { data.type = InputDataValidator::VALID_TYPES[:recurring] }

      it 'uses a recurring gateway' do
        result = Result.new(VALID_STRIPE_SUBSCRIPTION, [])
        expect(StripeWrapper::Recurring).to receive(:charge).and_return(result)
        described_class.charge(data)
      end

      it 'returns no errors when payment is OK' do
        result = Result.new('irrelevant', [])
        expect(StripeWrapper::Recurring).to receive(:charge).and_return(result)
        expect(described_class.charge(data)).to be_okay
      end

      it 'has errors if payment fails' do
        bad_result = Result.new(nil, [:error])
        allow(StripeWrapper::Recurring).to receive(:charge).and_return(bad_result)
        expect(described_class.charge(data).errors).to include(:error)
      end
    end

    describe 'when selecting other gateways' do
      it 'selects the Paypal one off gateway' do
        result = Result.new(VALID_PAYPAL_PAYMENT, [])
        expect(PaypalWrapper::OneOff).to receive(:charge).and_return(result)
        described_class.charge(VALID_REQUEST_DATA_PAYPAL)
      end
    end
  end
end
