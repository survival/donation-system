# frozen_string_literal: true

require 'mail'

class ThankYouMailer
  class << self
    def send_email(email)
      Mail.deliver do
        to email
        from 'info@survivalinternational.org'
      end
    end
  end
end
