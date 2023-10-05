# frozen_string_literal: true

module Accounting
  class AccountingController < Common::ApplicationController
    FeeData = Struct.new(:currency, :fee)

    private_constant :FeeData

    def show(*)
      evaluation = Securities::Service.find_securites_value_per_currency

      @fees_per_currency = evaluation.map do |e|
        FeeData.new(e.currency, calculate_fee(e.value_in_currency))
      end

      @fees_usd = evaluation.sum { calculate_fee(_1.value_in_usd) }

      render(AccountingView)
    end

    private

    def calculate_fee(value) = Service.calculate_fee(value)
  end
end
