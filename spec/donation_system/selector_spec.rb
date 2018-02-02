# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/selector'
require 'spec_helper'

module DonationSystem
  RSpec.describe Selector do
    it 'has a gateway' do
      expect(Selector.select_gateway(VALID_REQUEST_DATA)).not_to be_nil
    end

    it 'has a adapter' do
      expect(Selector.select_adapter(VALID_REQUEST_DATA)).not_to be_nil
    end

    it 'returns nothing if there is no key match' do
      data = VALID_REQUEST_DATA.dup
      data.type = 'i-dont-exist'
      expect(Selector.select_gateway(data)).to be_nil
    end
  end
end
