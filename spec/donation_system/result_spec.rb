# frozen_string_literal: true

require 'donation_system/result'
require 'spec_helper'

module DonationSystem
  RSpec.describe Result do
    it 'has an item and errors' do
      result = Result.new('item', %w[error1 error2])
      expect(result.item).to eq('item')
      expect(result.errors).to eq(%w[error1 error2])
    end

    it 'is OK if it has no errors' do
      result = Result.new({ foo: 'bar' }, [])
      expect(result).to be_okay
    end

    it 'knows if it has errors' do
      result = Result.new(nil, %i[one two])
      expect(result.errors?).to be(true)
    end
  end
end
