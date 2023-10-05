# frozen_string_literal: true

module Accounting
  # The Accouting-API. Provides public access to the module.
  class Service
    class << self
      def calculate_fee(value)
        value * 0.01
      end
    end
  end
end
