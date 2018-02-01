# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/utils'
require 'spec_helper'

module DonationSystem
  RSpec.describe Utils do
    let(:utils) { Utils.new }

    it 'generates payment number' do
      allow(Random).to receive(:rand).and_return(0)
      expect(utils.generate_number('P')).to eq('P000000000')
    end

    it 'detects an integer' do
      expect(utils.integer?('1234')).to be_truthy
    end

    it 'detects a non-integer' do
      expect(utils.integer?('asdf')).to be_falsy
    end

    it 'formats seconds since epoch to date' do
      expect(utils.format_time(1_000_000_000)).to eq('2001-09-09')
    end

    it 'calculates an amount in currency units' do
      expect(utils.amount_in_currency_units(VALID_ONEOFF_PAYMENT_DATA))
        .to eq('12.34')
    end
  end
end
