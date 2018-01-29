# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/paypal_wrapper/creator_data_validator'
require 'spec_helper'

module DonationSystem
  RSpec.describe CreatorDataValidator do
    let(:data) { VALID_PAYPAL_CREATOR_DATA.dup }

    it 'has no validation errors if data is present' do
      result = validate(data)
      expect(result).to be_okay
    end

    it 'handles null data' do
      result = validate(nil)
      expect(result.errors).to include(:missing_data)
    end

    it 'handles missing amount' do
      data.amount = nil
      expect_validation_to_fail_with(:invalid_amount)
    end

    it 'handles invalid amount' do
      data.amount = 'asdf'
      expect_validation_to_fail_with(:invalid_amount)
    end

    it 'handles valid but negative amount' do
      data.amount = '-12.34567'
      expect_validation_to_fail_with(:invalid_amount)
    end

    it 'handles missing currency' do
      data.currency = nil
      expect_validation_to_fail_with(:invalid_currency)
    end

    it 'handles invalid currency' do
      data.currency = ''
      expect_validation_to_fail_with(:invalid_currency)
    end

    it 'handles unsupported currency' do
      data.currency = 'unsupported'
      expect_validation_to_fail_with(:invalid_currency)
    end

    it 'handles missing return url' do
      data.return_url = nil
      expect_validation_to_fail_with(:invalid_return_url)
    end

    it 'handles invalid return url' do
      data.return_url = ''
      expect_validation_to_fail_with(:invalid_return_url)
    end

    it 'handles unsupported return url' do
      data.return_url = 'unsupported'
      expect_validation_to_fail_with(:invalid_return_url)
    end

    it 'handles unsupported cancel url' do
      data.cancel_url = 'unsupported'
      expect_validation_to_fail_with(:invalid_cancel_url)
    end

    def expect_validation_to_fail_with(error)
      result = validate(data)
      expect(result.errors).to include(error)
    end

    def validate(data)
      described_class.execute(data)
    end
  end
end
