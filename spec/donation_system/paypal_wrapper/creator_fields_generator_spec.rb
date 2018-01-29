# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/paypal_wrapper/creator_fields_generator'
require 'spec_helper'

module DonationSystem
  module PaypalWrapper
    RSpec.describe CreatorFieldsGenerator do
      let(:fields) do
        allow(Random).to receive(:rand).and_return(0)
        described_class.execute(VALID_PAYPAL_CREATOR_DATA)
      end

      it 'has required field intent' do
        expect(fields[:intent]).to eq('sale')
      end

      it 'has required field payer' do
        expect(fields[:payer][:payment_method]).to eq('paypal')
      end

      it 'has required field for paypal method redirect urls' do
        expect(fields[:redirect_urls][:return_url]).not_to be_nil
        expect(fields[:redirect_urls][:cancel_url]).not_to be_nil
      end

      it 'has required field amount' do
        expect(fields[:transactions].first[:amount]).not_to be_nil
      end

      it 'has required field total with no more than 2 digits' do
        expect(fields[:transactions].first[:amount][:total]).to eq('12.34')
      end

      it 'has required field currency in uppercase' do
        expect(fields[:transactions].first[:amount][:currency]).to eq('GBP')
      end

      it 'has optional field description' do
        expect(fields[:transactions].first[:description]).to eq('P000000000')
      end
    end
  end
end
