# frozen_string_literal: true

class AccountingController < ApplicationController
  def show(*)
    holdings = Security.joins(user: { person: :address })
                       .group('addresses.country', 'securities.ticker')
                       .sum('securities.quantity')

    evaluated_holdings = holdings.map do |(country, ticker), quantity|
      fee_dollar = StockApi.get_share_price(ticker, Date.today) * quantity * Constants::FEE_RATE

      user = Address.find_by(country:).person.user
      currency = CurrencyHelper.find_currency(user)
      rate = CurrencyExchangeApi.find_conversion_rate('USD', currency, Date.today)
      fee_currency = fee_dollar * rate

      [currency, fee_currency, fee_dollar]
    end
    grouped_holdings = evaluated_holdings.group_by { |h| h[0] }

    @fees_per_currency = grouped_holdings.map do |key, values|
      [key, values.sum { |v| v[1] }]
    end
    @fees_usd = evaluated_holdings.sum { |h| h[2] }

    render(AccountingView)
  end
end
