# frozen_string_literal: true

module Salesforce
  RawSupporterData = Struct.new(:name, :email)
  RawDonationData = Struct.new(:amount)
  SupporterSObjectFake = Struct.new(:AccountId)
end
