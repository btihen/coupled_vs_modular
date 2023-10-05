# frozen_string_literal: true

module Securities
  # The Securities-API. Provides public access to the module.
  class Service
    SecuritiesValueData = Data.define(:currency, :value_in_currency, :value_in_usd)

    private_constant :SecuritiesValueData

    class << self
      def find_securites_value_per_currency
        find_ticker_quantity_per_currency.group_by(&:currency)
                                         .map do |currency, evaluations|
          value_in_usd = evaluations.sum(&:value_in_usd)
          value_in_currency = evaluations.sum(&:value_in_currency)

          SecuritiesValueData.new(currency:, value_in_usd:, value_in_currency:)
        end
      end

      def calculate_portfolio_value(user:)
        securities = Repository.find_securities(user.id)
        dollar_value = securities.sum { StockApi.get_share_price(_1.ticker, Date.today) * _1.quantity }
        rate = CurrencyExchangeApi.find_conversion_rate('USD', CurrencyHelper.find_currency(user.country), Date.today)
        dollar_value * rate
      end

      private

      def find_ticker_quantity_per_currency
        Repository.find_ticker_quantity_per_country.map do |ticker_quantity|
          value_in_usd = StockApi.get_share_price(ticker_quantity.ticker, Date.today) * ticker_quantity.quantity
          currency = CurrencyHelper.find_currency(ticker_quantity.country)
          exchange_rate = CurrencyExchangeApi.find_conversion_rate('USD', currency, Date.today)
          value_in_currency = exchange_rate * value_in_usd

          SecuritiesValueData.new(currency:, value_in_usd:, value_in_currency:)
        end
      end
    end
  end
end
