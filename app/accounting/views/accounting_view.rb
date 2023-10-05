# frozen_string_literal: true

module Accounting
  class AccountingView < View
    def title = 'Outstanding Fees'

    def content
      fees_details = @fees_per_currency.sort_by(&:currency)
                                       .map { "  #{format('%.2f', _1.fee)} #{_1.currency}" }

      fees_total = "  #{format('%.2f', @fees_usd)} USD"

      ['Fees:',  fees_details.join("\n"), 'Total:', fees_total].join("\n").chomp
    end
  end

  private_constant :AccountingView
end
