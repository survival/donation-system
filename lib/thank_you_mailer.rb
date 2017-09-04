# frozen_string_literal: true

require 'mail'

class ThankYouMailer
  class << self
    def send_email(recipient, first_name)
      Mail.deliver do
        to recipient
        from 'info@survivalinternational.org'
        body "Hello #{first_name}"
      end
    end
  end
end
