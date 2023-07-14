# frozen_string_literal: true

class InvestmentNewsBuilder
  def with_address(address)
    @address = address
    self
  end

  def build
    base_currency = 'USD'
    currency = CurrencyHelper.find_currency(@address.person.user)
    rate = CurrencyExchangeApi.find_conversion_rate(base_currency, currency, Date.today)
    "Exchange Rate #{base_currency}/#{currency}: #{rate}"
  end
end
