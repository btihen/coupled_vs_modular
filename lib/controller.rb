# frozen_string_literal: true

class Controller
  def instance_variables_hash
    vars = {}
    instance_variables.each { |var| vars[var] = instance_variable_get(var) }
    vars
  end

  protected

  def render(view_class)
    view = view_class.new(self)
    view.render
  end

  def redirect_to(controller_class, **)
    controller = controller_class.new
    controller.show(**)
  end
end
