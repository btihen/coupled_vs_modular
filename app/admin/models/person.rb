# frozen_string_literal: true

module Admin
  class Person < ActiveRecord::Base
    belongs_to :address, autosave: true
    has_many :name_versions

    def version_dates
      (
        name_versions.map(&:valid_from) +
        address.address_versions.map(&:valid_from)
      ).sort.uniq
    end

    def name
      name_versions.order(valid_from: :desc)
                   .first&.name
    end

    def name_on(date = Date.today)
      name_versions.where('valid_from <= ?', date)
                   .order(valid_from: :desc)
                   .first&.name
    end
  end

  private_constant :Person
end
