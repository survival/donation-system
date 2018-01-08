# frozen_string_literal: true

module DonationSystem
  RawRequestData = Struct.new(:amount, :currency, :giftaid, :token,
                              :name, :email,
                              :address, :city, :state, :zip, :country)
  OneOffPaymentData = Struct.new(:id, :status, :amount, :currency, :source,
                                 :created)

  StripePlanFake = Struct.new(:id)

  StripeCardData = Struct.new(:last4, :brand, :exp_month, :exp_year)
  VALID_STRIPE_CARD_DATA = StripeCardData.new('4242', 'Visa', '8', '2100')

  StripeCustomerFake = Struct.new(:id) do
    SourcesFake = Struct.new(:data)
    def sources
      SourcesFake.new([VALID_STRIPE_CARD_DATA])
    end
  end

  SupporterFake = Struct.new(:AccountId)

  VALID_REQUEST_DATA = RawRequestData.new(
    '12.345', 'gbp', true, 'tok_visa', 'Firstname Lastname', 'user@example.com',
    'Address', 'City', 'State', 'Z1PC0D3', 'Country'
  ).freeze

  VALID_PAYMENT_DATA = OneOffPaymentData.new(
    'ch_1BPDARGjXKYZTzxWrD35FFDc', 'succeeded', 1234, 'gbp',
    VALID_STRIPE_CARD_DATA, 1_510_917_211
  ).freeze
end
