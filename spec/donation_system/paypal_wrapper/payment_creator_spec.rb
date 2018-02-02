# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/paypal_wrapper/payment_creator'
require 'support/with_env'
require 'spec_helper'

module DonationSystem
  module PaypalWrapper
    RSpec.describe PaymentCreator do
      include Support::WithEnv

      let(:result) do
        described_class.execute(VALID_PAYPAL_CREATOR_DATA)
      end

      describe 'when successful', vcr: { record: :once } do
        it 'works' do
          expect(result).to be_okay
        end

        it 'returns the payment' do
          expect(result.item.id).to include('PAY-')
        end
      end

      describe 'when unsuccessful', vcr: { record: :once } do
        let(:paypal_payment) { PayPal::SDK::REST::DataTypes::Payment }

        it 'fails if there are problems with input data validation' do
          result = described_class.execute(nil)
          expect(result).not_to be_okay
        end

        it 'does not work if fields are missing' do
          allow(paypal_payment).to receive(:new).and_return(paypal_payment.new)
          expect(result.errors).to include(:validation_error)
        end

        it 'does not work without a client id' do
          with_env('PAYPAL_CLIENT_ID' => nil) do
            expect(result.errors).to include(:unauthorized_access)
          end
        end

        it 'fails if there are server errors' do
          allow_any_instance_of(paypal_payment).to receive(:create)
            .and_raise(PayPal::SDK::Core::Exceptions::ServerError, 'response')
          expect(result.errors).to include(:internal_server_error)
        end

        it 'can fail for other reasons' do
          allow_any_instance_of(paypal_payment).to receive(:create)
            .and_raise(StandardError, 'error')
          expect(result.errors).to include(:unknown_error)
        end
      end
    end
  end
end
