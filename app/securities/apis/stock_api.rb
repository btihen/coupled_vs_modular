# frozen_string_literal: true

module Securities
  class StockApi
    class << self
      def get_share_price(security_id, _date)
        case security_id
        when 'AAPL'
          100
        when 'GOOG'
          200
        when 'AMZN'
          300
        else
          raise 'Are you kidding me? This stock does not exist!'
        end
      end
    end
  end

  private_constant :StockApi
end
