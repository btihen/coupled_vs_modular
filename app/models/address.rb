# frozen_string_literal: true

class Address < ActiveRecord::Base
  has_one :person
end
