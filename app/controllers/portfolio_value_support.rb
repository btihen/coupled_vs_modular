# frozen_string_literal: true

module PortfolioValueSupport
  def calculate_portfolio_value(user:)
    securities = user.securities
    dollar_value = securities.sum { StockApi.get_share_price(_1.ticker, Date.today) * _1.quantity }
    rate = CurrencyExchangeApi.find_conversion_rate('USD', CurrencyHelper.find_currency(user), Date.today)
    dollar_value * rate
  end
end
