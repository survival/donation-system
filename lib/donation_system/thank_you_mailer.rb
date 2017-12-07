# frozen_string_literal: true

require 'mail'

module DonationSystem
  class ThankYouMailer
    def self.send_email(recipient, first_name, protocol = :smtp)
      configure(protocol)
      Mail.deliver do
        to recipient
        from 'info@survivalinternational.org'
        subject 'Thank you for your donation'
        body "Thank you for your donation #{first_name}"
      end
    end

    def self.configure(protocol)
      Mail.defaults do
        delivery_method(
          protocol,
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
