# frozen_string_literal: true

require 'spec_helper'

module DonationSystem
  module Adapters
    RSpec.shared_examples 'Input payment data' do
      it 'responds to type' do
        expect(payment_data.type).not_to be_nil
      end

      it 'responds to giftaid' do
        expect(payment_data.giftaid).to be_truthy
      end

      it 'responds to name' do
        expect(payment_data.name).to eq('Firstname Lastname')
      end

      it 'responds to email' do
        expect(payment_data.email).to eq('user@example.com')
      end

      it 'responds to address' do
        expect(payment_data.address).to eq('Address')
      end

      it 'responds to city' do
        expect(payment_data.city).to eq('City')
      end

      it 'responds to state' do
        expect(payment_data.state).to eq('State')
      end

      it 'responds to zip' do
        expect(payment_data.zip).to eq('Z1PC0D3')
      end

      it 'responds to country' do
        expect(payment_data.country).to eq('Country')
      end
    end

    RSpec.shared_examples 'Salesforce one-off payment data' do
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

    RSpec.shared_examples 'Salesforce recurring payment data' do
      it 'responds to expiry month' do
        expect(payment_data.expiry_month).to eq('8')
      end

      it 'responds to expiry year' do
        expect(payment_data.expiry_year).to eq('2100')
      end

      it 'responds to start_date' do
        expect(payment_data.start_date > 1_000_000_000).to be_truthy
      end

      it 'responds to reference' do
        expect(payment_data).to respond_to(:reference)
      end

      it 'responds to collection_day' do
        expect(payment_data).to respond_to(:collection_day)
      end

      it 'responds to mandate_method' do
        expect(payment_data).to respond_to(:mandate_method)
      end

      it 'responds to account_holder_name' do
        expect(payment_data).to respond_to(:account_holder_name)
      end
    end
  end
end
