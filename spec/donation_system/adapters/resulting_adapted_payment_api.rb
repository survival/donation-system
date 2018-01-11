# frozen_string_literal: true

require 'spec_helper'

module DonationSystem
  module Adapters
    RSpec.shared_examples 'Salesforce payment data' do
      it 'responds to id' do
        expect(payment_data.id).not_to be_nil
      end

      it 'responds to amount in cents' do
        expect(payment_data.amount).to eq(1234)
      end

      it 'responds to currency' do
        expect(payment_data.currency).to eq('gbp')
      end

      it 'responds to creation date in seconds since epoch' do
        expect(payment_data.created > 1_000_000_000).to be_truthy
      end

      it 'responds to received' do
        expect(payment_data.received?).to be_truthy
      end

      it 'responds to last four digits of the card' do
        expect(payment_data.last4).to eq('4242')
      end

      it 'responds to brand' do
        expect(payment_data.brand).to eq('Visa')
      end

      it 'responds to a payment method' do
        expect(payment_data.method).to eq(described_class::PAYMENT_METHOD)
      end

      it 'responds to a record type id' do
        expect(payment_data.record_type_id).to eq(described_class::RECORD_TYPE_ID)
      end

      it 'responds to a payment number' do
        expect(payment_data.number).not_to be_nil
      end

      it 'responds to oneoff?' do
        expect(payment_data.oneoff?).not_to be_nil
      end
    end
  end
end
