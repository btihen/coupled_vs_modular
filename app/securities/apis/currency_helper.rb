# frozen_string_literal: true

module Securities
  class CurrencyHelper
    class << self
      def find_currency(country) # rubocop:disable Metrics/MethodLength
        case country
        when 'CH'
          'CHF'
        when 'DE'
          'EUR'
        when 'US'
          'USD'
        when 'UK'
          'GBP'
        else
          raise 'Unknown country'
        end
      end
    end
  end

  private_constant :CurrencyHelper
end
