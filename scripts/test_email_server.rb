# frozen_string_literal: true

require 'mail'
require_relative '../lib/donation_system/thank_you_mailer'

def main
  DonationSystem::ThankYouMailer.send_email(ARGV[0], 'foo')
end

main
