# frozen_string_literal: true

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
  end
end
