# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/stripe_wrapper/one_off'
require 'spec_helper'
require 'support/with_env'

module DonationSystem
  module StripeWrapper
    RSpec.describe OneOff do
      let(:data) { VALID_REQUEST_DATA.dup }
      let(:result) { Result.new({ id: 'id' }, []) }

      before { allow(ResourceCreator).to receive(:create).and_return(result) }

      describe 'when successful', vcr: { record: :once } do
        it 'has no errors' do
          expect(described_class.charge(data)).to be_okay
          expect(described_class.charge(data).item).to eq(id: 'id')
        end

        it 'creates a charge' do
          expect(ResourceCreator).to receive(:create)
            .with(Stripe::Charge, anything)
          described_class.charge(data)
        end

        it 'uses the fields for a charge' do
          expect_any_instance_of(FieldsGenerator).to receive(:for_charge)
          described_class.charge(data)
        end
      end
    end
  end
end
