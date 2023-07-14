# frozen_string_literal: true

class View
  def initialize(controller)
    @controller = controller
  end

  delegate :logout, to: :controller

  def render
    copy_controller_variables_to_view

    Application.instance.current_view = self
  end

  private

  attr_reader :controller

  def copy_controller_variables_to_view
    controller.instance_variables_hash.each do |var, value|
      instance_variable_set(var, value)
    end
  end
end
