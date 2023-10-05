# frozen_string_literal: true

module Securities
  class Repository
    SecurityData = Data.define(:ticker, :quantity)
    TickerQuantityData = Data.define(:ticker, :quantity, :country)

    private_constant :SecurityData

    class << self
      def find_securities(user_id)
        securities = Security.where(user_id:)
        securities.map { SecurityData.new(ticker: _1.ticker, quantity: _1.quantity) }
      end

      def find_ticker_quantity_per_country
        users = find_user_and_country
        securities = find_country_ticker_quantity(users)
        groups = group_by_country_and_ticker(securities)
        sum_quantities_per_country_and_ticker(groups)
      end

      private

      def find_user_and_country
        Admin::Service.find_user_and_country
                      .each_with_object({}) { |user, acc| acc[user.user_id] = user.country }
      end

      def find_country_ticker_quantity(users)
        Security.pluck(:user_id, :ticker, :quantity)
                .map { |user_id, ticker, quantity| [users[user_id], ticker, quantity] }
      end

      def group_by_country_and_ticker(securities)
        securities.group_by { |country, ticker, _| [country, ticker] }
      end

      def sum_quantities_per_country_and_ticker(groups)
        groups.transform_values { |value| value.sum(&:last) }
              .map { |(country, ticker), quantity| TickerQuantityData.new(ticker:, quantity:, country:) }
      end
    end
  end

  private_constant :Repository
end
