# frozen_string_literal: true

class InvestmentNewsView < View
  def title = "#{@user.person.name}'s news"

  def content = @news
end
