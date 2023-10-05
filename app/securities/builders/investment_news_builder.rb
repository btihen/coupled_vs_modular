# frozen_string_literal: true

module Securities
  class InvestmentNewsBuilder
    def with_user(user)
      @user = user
      self
    end

    def build
      base_currency = 'USD'
      currency = CurrencyHelper.find_currency(@user.country)
      rate = CurrencyExchangeApi.find_conversion_rate(base_currency, currency, Date.today)
      "Exchange Rate #{base_currency}/#{currency}: #{rate}"
    end
  end

  private_constant :InvestmentNewsBuilder
end
