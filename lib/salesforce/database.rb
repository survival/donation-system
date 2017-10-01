# frozen_string_literal: true

require 'salesforce/donation_creator'
require 'salesforce/supporter_creator'
require 'salesforce/supporter_finder'

module Salesforce
  class Database
    def self.add_donation(data)
      new(data).add_donation
    end

    def initialize(data)
      @data = data
    end

    def add_donation
      return [:missing_email] unless email_present?
      return supporter_result.errors unless supporter_result.okay?
      create_donation.errors
    end

    private

    attr_reader :data

    def email_present?
      data.respond_to?(:email) && data.email
    end

    def supporter_result
      @supporter_result ||= ensure_supporter_result
    end

    def ensure_supporter_result
      return supporter_search_result if search_errors_or_supporter_exists?
      create_supporter
    end

    def search_errors_or_supporter_exists?
      supporter_search_result.errors? || supporter_search_result.item
    end

    def supporter
      supporter_result.item
    end

    def supporter_search_result
      @supporter_search_result ||= SupporterFinder.execute(:Email, data.email)
    end

    def create_supporter
      SupporterCreator.execute(data)
    end

    def create_donation
      DonationCreator.execute(data, supporter)
    end
  end
end
