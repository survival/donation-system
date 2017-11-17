# frozen_string_literal: true

module DonationSystem
  RawRequestData = Struct.new(:amount, :currency, :giftaid, :token,
                              :name, :email,
                              :address, :city, :state, :zip, :country)
  RawPaymentData = Struct.new(:status)
  RawSupporterData = Struct.new(:name, :email)
  RawDonationData = Struct.new(:amount)
  SupporterFake = Struct.new(:AccountId)

  VALID_REQUEST_DATA = RawRequestData.new(
    '12.345', 'gbp', true, 'tok_visa', 'Firstname Lastname', 'user@example.com',
    'Address', 'City', 'State', 'Z1PC0D3', 'Country'
  ).freeze

  VALID_PAYMENT_DATA = RawPaymentData.new('succeeded').freeze
end
