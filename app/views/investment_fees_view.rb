# frozen_string_literal: true

class InvestmentFeesView < View
  def title = "#{@user.person.name}'s fees (in #{currency})"

  def content
    if @fees.positive?
      "Fees: #{format('%.2f', @fees)} #{currency}"
    else
      'there are no fees'
    end
  end

  private

  def currency = CurrencyHelper.find_currency(@user)
end
