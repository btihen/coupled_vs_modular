# frozen_string_literal: true

module Securities
  class InvestmentNewsController < Common::ApplicationController
    def show(user_id:)
      @user = Admin::Service.find_user(user_id)

      @news = InvestmentNewsBuilder.new.with_user(@user).build

      render(InvestmentNewsView)
    end
  end
end
