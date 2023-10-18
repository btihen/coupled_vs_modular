# frozen_string_literal: true

class Address < ActiveRecord::Base
  has_one :person
  has_many :address_versions

  def last
    address_versions.order(valid_from: :desc).first
  end

  def on(date = Date.today)
    address_versions.where('valid_from <= ?', date).order(valid_from: :desc).first
  end
end
