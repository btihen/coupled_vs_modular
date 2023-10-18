# frozen_string_literal: true

class CurrencyHelper
  class << self
    def find_currency(user)
      case user.person.address.on(Date.today).country
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
