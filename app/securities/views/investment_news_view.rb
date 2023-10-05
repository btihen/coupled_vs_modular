# frozen_string_literal: true

module Securities
  class InvestmentNewsView < View
    def title = "#{@user.name}'s news"

    def content = @news
  end

  private_constant :InvestmentFeesView
end
