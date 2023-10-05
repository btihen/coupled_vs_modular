# frozen_string_literal: true

module Securities
  class InvestmentFeesView < View
    def title = "#{@user.name}'s fees (in #{currency})"

    def content
      if @fees.positive?
        "Fees: #{format('%.2f', @fees)} #{currency}"
      else
        'there are no fees'
      end
    end

    private

    def currency = CurrencyHelper.find_currency(@user.country)
  end

  private_constant :InvestmentFeesView
end
