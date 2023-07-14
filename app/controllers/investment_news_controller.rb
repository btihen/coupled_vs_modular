# frozen_string_literal: true

class InvestmentNewsController < ApplicationController
  def show(user_id:)
    @user = User.find(user_id)

    @news = InvestmentNewsBuilder.new.with_address(@user.person.address).build

    render(InvestmentNewsView)
  end
end
