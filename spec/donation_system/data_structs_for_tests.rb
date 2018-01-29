# frozen_string_literal: true

module DonationSystem
  RawRequestData = Struct.new(:type, :amount, :currency, :giftaid, :token,
                              :name, :email,
                              :address, :city, :state, :zip, :country,
                              :method)

  AdaptedOneOffPaymentData = Struct.new(
    :type, :giftaid, :name, :email, :address, :city, :state, :zip, :country,
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

  AdaptedRecurringPaymentData = Struct.new(
    :type, :giftaid, :name, :email, :address, :city, :state, :zip, :country,
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

  PaypalToken = Struct.new(:payment_id, :payer_id)
  VALID_REQUEST_DATA_PAYPAL = RawRequestData.new(
    'one-off', '12.345', 'gbp', true,
    PaypalToken.new('PAY-13J25512E99606838LJU7M4Y', 'DUFRQ8GWYMJXC'),
    nil, '', nil, nil, nil, nil, nil,
    'paypal'
  ).freeze

  VALID_ONEOFF_PAYMENT_DATA = AdaptedOneOffPaymentData.new(
    'one-off', true, 'Firstname Lastname', 'user@example.com',
    'Address', 'City', 'State', 'Z1PC0D3', 'Country',
    'ch_1BPDARGjXKYZTzxWrD35FFDc', 1234, 'gbp', 1_510_917_211, '4242',
    'Visa', 'Card (Stripe)', '01280000000Fvqi', 'P123456789'
  ).freeze

  VALID_RECURRING_PAYMENT_DATA = AdaptedRecurringPaymentData.new(
    'recurring', true, 'Firstname Lastname', 'user@example.com',
    'Address', 'City', 'State', 'Z1PC0D3', 'Country',
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

  PaypalCreatorData = Struct.new(:amount, :currency, :return_url, :cancel_url)
  VALID_PAYPAL_CREATOR_DATA = PaypalCreatorData.new(
    '12.345', 'gbp', 'https://your-return-url.com', 'https://your-cancel-url.com'
  ).freeze

  PaypalPaymentFake = Struct.new(
    :id, :create_time, :state, :error, :transactions, :payer
  ) do
    def execute(_payer_id)
      true
    end
  end
  PaypalTransactionFake = Struct.new(:amount, :description)
  PaypalAmountFake = Struct.new(:total, :currency)
  PaypalPayer = Struct.new(:payer_info)
  PaypalPayerInfo = Struct.new(:first_name, :last_name, :email, :shipping_address)
  PaypalShippingAddress = Struct.new(
    :line1, :city, :state, :postal_code, :country_code
  )
  VALID_PAYPAL_PAYMENT = PaypalPaymentFake.new(
    'PAY-13J25512E99606838LJU7M4Y', '2018-01-30T14:59:00Z', 'approved', nil,
    [PaypalTransactionFake.new(
      PaypalAmountFake.new('12.34', 'GBP'), 'P987654321'
    )],
    PaypalPayer.new(
      PaypalPayerInfo.new(
        'Firstname', 'Lastname', 'user@example.com',
        PaypalShippingAddress.new(
          'Address', 'City', 'State', 'Z1PC0D3', 'Country'
        )
      )
    )
  )
end
