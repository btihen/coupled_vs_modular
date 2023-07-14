# frozen_string_literal: true

class User < ActiveRecord::Base
  belongs_to :person, autosave: true
  has_many :securities

  def admin? = is_admin
end
