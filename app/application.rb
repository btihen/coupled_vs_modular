# frozen_string_literal: true

require 'zeitwerk'
require 'active_support/all'
require 'active_model'
require 'active_record'
require 'controller'
require 'view'

require 'pry'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)

%w[controllers models views apis builders].each { loader.collapse("#{__dir__}/*/#{_1}") }

loader.push_dir(__dir__)
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
    controller = Admin::LoginController.new
    controller.show
  end

  def seed_data
    Admin::Service.seed_data
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
