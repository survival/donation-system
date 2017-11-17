# frozen_string_literal: true

module DonationSystem
  RawSupporterData = Struct.new(:name, :email)
  RawDonationData = Struct.new(:amount)
  SupporterSObjectFake = Struct.new(:AccountId)
end
