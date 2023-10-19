# frozen_string_literal: true

require 'zeitwerk'
require 'active_support/all'
require 'active_model'
require 'active_record'
require 'controller'
require 'view'

require 'pry'

loader = Zeitwerk::Loader.for_gem

loader.push_dir(__dir__)
%w[views controllers models apis builders].each do |dir|
  loader.push_dir("#{__dir__}/#{dir}")
end

loader.setup

# This is the entry point for this messy application. Lionel didn't want it to be that way.
class Application
  def load
    seed_data
    show_login
  end

  attr_accessor :current_view, :current_user

  private

  def show_login
    controller = LoginController.new
    controller.show
  end

  def seed_data
    User.create(email: 'admin@messy.com', password: '&£78fsasd', is_admin: true, person_id: nil)
  end

  class << self
    def instance
      @instance ||= new
    end

    def reset
      @instance = nil
    end
  end
end
