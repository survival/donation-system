# frozen_string_literal: true

module DonationSystem
  RawRequestData = Struct.new(:type, :amount, :currency, :giftaid, :token,
                              :name, :email,
                              :address, :city, :state, :zip, :country,
                              :method)
  OneOffPaymentData = Struct.new(
    :id, :amount, :currency, :created, :last4, :brand, :method, :record_type_id,
    :number
  ) do
    def received?
      true
    end

    def oneoff?
      true
    end
  end

  RecurringPaymentData = Struct.new(
    :id, :amount, :currency, :created, :last4, :brand, :method, :record_type_id,
    :number, :expiry_month, :expiry_year, :start_date, :reference,
    :collection_day, :mandate_method, :account_holder_name
  ) do
    def oneoff?
      false
    end
  end

  StripePlanFake = Struct.new(:id)

  StripeCardData = Struct.new(:last4, :brand, :exp_month, :exp_year)
  VALID_STRIPE_CARD_DATA = StripeCardData.new('4242', 'Visa', '8', '2100')

  StripeCustomerFake = Struct.new(:id) do
    SourcesFake = Struct.new(:data)
    def sources
      SourcesFake.new([VALID_STRIPE_CARD_DATA])
    end
  end

  SupporterFake = Struct.new(:Id, :AccountId)

  VALID_REQUEST_DATA = RawRequestData.new(
    'one-off', '12.345', 'gbp', true, 'tok_visa',
    'Firstname Lastname', 'user@example.com',
    'Address', 'City', 'State', 'Z1PC0D3', 'Country',
    'stripe'
  ).freeze

  VALID_ONEOFF_PAYMENT_DATA = OneOffPaymentData.new(
    'ch_1BPDARGjXKYZTzxWrD35FFDc', 1234, 'gbp', 1_510_917_211, '4242',
    'Visa', 'Card (Stripe)', '01280000000Fvqi', 'P123456789'
  ).freeze

  VALID_RECURRING_PAYMENT_DATA = RecurringPaymentData.new(
    'sub_C6wrGA60bGiHfV', 1234, 'gbp', 1_510_917_211, '4242',
    'Visa', 'Card (Stripe)', '01280000000Fvsz', 'MC123456789',
    8, 2100, 1_510_917_211, nil, nil, nil, nil
  ).freeze

  ChargeSourceFake = Struct.new(:last4, :brand)
  ChargeMetadataFake = Struct.new(:number)
  StripeChargeFake = Struct.new(
    :id, :amount, :currency, :created, :status, :source, :metadata
  )
  VALID_STRIPE_CHARGE = StripeChargeFake.new(
    'ch_1BPDARGjXKYZTzxWrD35FFDc', 1234, 'gbp', 1_510_917_211, 'succeeded',
    ChargeSourceFake.new('4242', 'Visa'), ChargeMetadataFake.new('P123456789')
  )

  SubscriptionPlanFake = Struct.new(:amount, :currency)
  SubscriptionMetadataFake = Struct.new(
    :last4, :brand, :expiry_month, :expiry_year, :number
  )
  StripeSubscriptionFake = Struct.new(
    :id, :created, :status, :plan, :metadata, :current_period_start
  )
  VALID_STRIPE_SUBSCRIPTION = StripeSubscriptionFake.new(
    'sub_C6wrGA60bGiHfV', 1_510_917_211, 'active',
    SubscriptionPlanFake.new(1234, 'gbp'),
    SubscriptionMetadataFake.new('4242', 'Visa', '8', '2100', 'MC123456789'),
    1_510_917_211
  )
end
