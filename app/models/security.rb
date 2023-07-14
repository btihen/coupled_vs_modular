# frozen_string_literal: true

class Security < ActiveRecord::Base
  belongs_to :user
end
