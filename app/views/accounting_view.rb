# frozen_string_literal: true

class AccountingView < View
  def title = 'Outstanding Fees'

  def content
    fees_details = @fees_per_currency.sort_by { |f| f[0] }.map do |currency, fees|
      "  #{format('%.2f', fees)} #{currency}"
    end
    fees_total = "  #{format('%.2f', @fees_usd)} USD"

    ['Fees:',  fees_details.join("\n"), 'Total:', fees_total].join("\n").chomp
  end
end
