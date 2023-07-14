# frozen_string_literal: true

class ApplicationController < Controller
  delegate :current_user, :current_user=, to: :application

  def logout
    self.current_user = nil

    redirect_to(LoginController)
  end

  private

  def application = Application.instance
end
