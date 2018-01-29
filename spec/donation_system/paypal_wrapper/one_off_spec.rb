# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/paypal_wrapper/one_off'
require 'support/with_env'
require 'spec_helper'

module DonationSystem
  module PaypalWrapper
    RSpec.describe OneOff do
      include Support::WithEnv

      let(:result) do
        described_class.charge(VALID_REQUEST_DATA_PAYPAL)
      end

      describe 'when successful', vcr: { record: :once } do
        it 'executes the payment' do
          allow(PayPal::SDK::REST::DataTypes::Payment)
            .to receive(:find).and_return(PaypalPaymentFake.new('id', nil))
          expect(result).to be_okay
        end
      end

      describe 'when unsuccessful', vcr: { record: :once } do
        let(:paypal_payment) { PayPal::SDK::REST::DataTypes::Payment }

        it 'fails if payment does not exist' do
          allow(paypal_payment).to receive(:find).and_return(nil)
          expect(result.errors).to include(:payment_not_found)
        end

        it 'fails if payer does not exist' do
          data = VALID_REQUEST_DATA_PAYPAL.dup
          data.token = PaypalToken.new(
            'PAY-13J25512E99606838LJU7M4Y', 'i-dont-exist'
          )
          allow(paypal_payment).to receive(:find).and_return(paypal_payment.new)
          result = described_class.charge(data)
          expect(result.errors).to include(:malformed_request)
        end

        it 'fails without a client id' do
          with_env('PAYPAL_CLIENT_ID' => nil) do
            expect(result.errors).to include(:unauthorized_access)
          end
        end

        it 'fails if there are server errors' do
          allow(paypal_payment).to receive(:find).and_return(paypal_payment.new)
          allow_any_instance_of(paypal_payment).to receive(:execute)
            .and_raise(PayPal::SDK::Core::Exceptions::ServerError, 'response')
          expect(result.errors).to include(:internal_server_error)
        end

        it 'can fail for other reasons' do
          allow(paypal_payment).to receive(:find).and_return(paypal_payment.new)
          allow_any_instance_of(paypal_payment).to receive(:execute)
            .and_raise(StandardError, 'error')
          expect(result.errors).to include(:unknown_error)
        end
      end
    end
  end
end
