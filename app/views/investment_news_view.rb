# frozen_string_literal: true

class InvestmentNewsView < View
  def title = "#{@user.person.name_on(Date.today)}'s news"

  def content = @news
end
