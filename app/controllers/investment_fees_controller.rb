# frozen_string_literal: true

class InvestmentFeesController < ApplicationController
  include PortfolioValueSupport

  def show(user_id:)
    @user = User.find(user_id)

    @fees = calculate_portfolio_value(user: @user) * Constants::FEE_RATE

    render(InvestmentFeesView)
  end
end
