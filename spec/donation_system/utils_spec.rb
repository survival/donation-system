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

    it 'detects an number' do
      expect(utils.number?('12.34')).to be(true)
    end

    it 'detects a non-number' do
      expect(utils.number?('not an number')).to be(false)
    end

    it 'converts to number' do
      expect(utils.number('12.34')).to eq(12.34)
    end

    it 'detects a currency' do
      expect(utils.currency?('gbp')).to be(true)
      expect(utils.currency?('GBP')).to be(true)
    end

    it 'detects a non-currency' do
      expect(utils.currency?('not a currency')).to be(false)
    end

    it 'detects a date' do
      expect(utils.date?('2001-09-09')).to be(true)
    end

    it 'detects a non-date' do
      expect(utils.date?('not a date')).to be(false)
    end

    it 'detects a url' do
      expect(utils.url?('http://hello.com')).to be(true)
    end

    it 'detects a non-url' do
      expect(utils.url?('not a url')).to be(false)
    end

    it 'formats date or seconds since epoch to date' do
      expect(utils.format_date(1_000_000_000)).to eq('2001-09-09')
      expect(utils.format_date('2017-11-17T14:59:00Z')).to eq('2017-11-17')
    end

    it 'calculates an amount in cents' do
      expect(utils.amount_in_cents(1234, 'gbp')).to eq(1234)
      expect(utils.amount_in_cents('12.34', 'gbp')).to eq(1234)
    end

    it 'calculates an amount in currency units' do
      expect(utils.amount_in_currency_units(1234, 'gbp')).to eq('12.34')
      expect(utils.amount_in_currency_units('12.34', 'gbp')).to eq('12.34')
    end

    it 'calculates the currency in uppercase' do
      expect(utils.currency_in_uppercase('gbp')).to eq('GBP')
    end
  end
end
