# frozen_string_literal: true

require 'donation_system/salesforce/data_structs_for_tests'
require 'donation_system/salesforce/supporter_validator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe SupporterValidator do
      let(:data) { RawSupporterData.new('A Name', 'test@test.com') }
      let(:result) { validate(data) }
      let(:fields) { result.item }

      describe 'Salesforce required fields' do
        it 'requires a last name' do
          expect(fields[:LastName]).to eq('A Name')
        end
      end

      describe 'application required fields' do
        it 'requires an email' do
          expect(fields[:Email]).to eq('test@test.com')
        end
      end

      describe 'validations' do
        it 'has no validation errors if data is valid' do
          expect(result).to be_okay
          expect(fields).not_to be_nil
        end

        it 'handles null data' do
          result = validate(nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_data)
        end

        it 'handles missing last name' do
          result = validate(RawSupporterData.new(nil, 'test@test.com'))
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_last_name)
        end

        it 'handles missing email' do
          result = validate(RawSupporterData.new('A Name', nil))
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_email)
        end
      end

      def validate(data)
        described_class.execute(data)
      end
    end
  end
end
