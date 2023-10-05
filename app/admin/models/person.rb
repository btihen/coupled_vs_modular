# frozen_string_literal: true

module Admin
  class Person < ActiveRecord::Base
    belongs_to :address, autosave: true
  end

  private_constant :Person
end
