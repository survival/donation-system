# frozen_string_literal: true

module DonationSystem
  RawSupporterData = Struct.new(:name, :email)
  RawDonationData = Struct.new(:amount)
  SupporterFake = Struct.new(:AccountId)
end
