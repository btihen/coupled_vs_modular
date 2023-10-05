# frozen_string_literal: true

module Securities
  class InvestmentFeesController < Common::ApplicationController
    def show(user_id:)
      @user = Admin::Service.find_user(user_id)

      value = Service.calculate_portfolio_value(user: @user)
      @fees = Accounting::Service.calculate_fee(value)

      render(InvestmentFeesView)
    end
  end
end
