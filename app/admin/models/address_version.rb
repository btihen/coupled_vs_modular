# frozen_string_literal: true

module Admin
  class AddressVersion < ActiveRecord::Base
    belongs_to :address

    scope :on_date, lambda { |date|
      where('valid_from <= ?', date)
        .order(valid_from: :desc)
        .limit(1)
    }
  end

  private_constant :AddressVersion
end
