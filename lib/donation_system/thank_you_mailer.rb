# frozen_string_literal: true

require 'mail'

module DonationSystem
  class ThankYouMailer
    def self.send_email(recipient, first_name)
      configure
      Mail.deliver do
        to recipient
        from 'info@survivalinternational.org'
        subject 'Thank you for your donation'
        body "Thank you for your donation #{first_name}"
      end
    end

    def self.configure
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
    end
  end
end
