# frozen_string_literal: true

module Admin
  class NameVersion < ActiveRecord::Base
    belongs_to :person
  end

  private_constant :NameVersion
end
