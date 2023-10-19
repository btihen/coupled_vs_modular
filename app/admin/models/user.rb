# frozen_string_literal: true

module Admin
  class User < ActiveRecord::Base
    belongs_to :person, autosave: true

    delegate :version_dates, to: :person

    def admin? = is_admin
  end

  private_constant :User
end
