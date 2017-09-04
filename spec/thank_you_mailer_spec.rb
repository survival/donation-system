# frozen_string_literal: true

require 'spec_helper'
require 'thank_you_mailer'

RSpec.describe ThankYouMailer do
  let(:email) { ThankYouMailer.send_email('user@example.com', 'Firstname') }

  it 'requires a from field' do
    expect(email.from).not_to be(nil)
  end

  it 'sends an email to the receiver' do
    expect(email.to).to eq(['user@example.com'])
  end

  it 'sends a simple text email including the person name' do
    expect(email.body).to include('Firstname')
  end
end
