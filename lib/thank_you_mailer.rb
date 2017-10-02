# frozen_string_literal: true

require 'mail'

class ThankYouMailer
  def self.send_email(recipient, first_name)
    Mail.deliver do
      to recipient
      from 'info@survivalinternational.org'
      subject 'Thank you for your donation'
      body "Thank you for your donation #{first_name}"
    end
  end
end
