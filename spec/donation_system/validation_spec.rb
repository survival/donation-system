# frozen_string_literal: true

require 'donation_system/validation'
require 'spec_helper'

module DonationSystem
  RSpec.describe Validation do
    let(:validation) { Validation.new }

    it 'stores errors' do
      validation << 'error1'
      validation << 'error2'
      expect(validation.errors).to eq(%w[error1 error2])
    end

    it 'is OK if it has no errors' do
      expect(validation).to be_okay
    end
  end
end
