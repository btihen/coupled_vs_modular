# frozen_string_literal: true

class CurrencyExchangeApi
  class << self
    def find_conversion_rate(from, to, _date) # rubocop:disable Metrics/MethodLength
      raise 'rates can only be converted from USD' unless from == 'USD'

      case to
      when 'USD'
        1
      when 'EUR'
        0.89
      when 'CHF'
        0.97
      when 'GBP'
        0.8
      else
        raise 'unsupported currency'
      end
    end
  end
end
