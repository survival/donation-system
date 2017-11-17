# frozen_string_literal: true

module DonationSystem
  RawRequestData = Struct.new(:amount, :currency, :giftaid, :token,
                              :name, :email,
                              :address, :city, :state, :zip, :country)
  StripeCardData = Struct.new(:brand, :last4)
  RawPaymentData = Struct.new(:id, :status, :amount, :currency, :source, :created)
  SupporterFake = Struct.new(:AccountId)

  VALID_REQUEST_DATA = RawRequestData.new(
    '12.345', 'gbp', true, 'tok_visa', 'Firstname Lastname', 'user@example.com',
    'Address', 'City', 'State', 'Z1PC0D3', 'Country'
  ).freeze

  VALID_STRIPE_CARD_DATA = StripeCardData.new('Visa', '4242').freeze

  VALID_PAYMENT_DATA = RawPaymentData.new(
    'ch_1BPDARGjXKYZTzxWrD35FFDc', 'succeeded', 1234, 'gbp',
    VALID_STRIPE_CARD_DATA, 1_510_917_211
  ).freeze
end
