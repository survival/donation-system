# frozen_string_literal: true

require 'mail'
require_relative '../lib/thank_you_mailer'

Mail.defaults do
  delivery_method(
    :smtp,
    address: ENV['EMAIL_SERVER'],
    port: 587,
    user_name: ENV['EMAIL_USERNAME'],
    password: ENV['EMAIL_PASSWORD'],
    enable_ssl: false
  )
end

def main
  ThankYouMailer.send_email(ARGV[0], 'foo')
end

main
