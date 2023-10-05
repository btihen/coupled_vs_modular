# frozen_string_literal: true

module Securities
  class NotFoundView < View
    def title = 'Uuppss'

    def content = '404, page not found'
  end
  private_constant :NotFoundView
end
