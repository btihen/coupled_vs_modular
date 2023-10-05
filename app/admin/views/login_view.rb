# frozen_string_literal: true

module Admin
  class LoginView < View
    # view content
    def title = 'Messy App'

    def content
      if @user
        'Thanks for signing up. Please login now.'
      elsif @login_failed
        'Username or password is invalid'
      elsif @passcode_failed
        'Passcode incorrect. Please try again or request a new one.'
      else
        'Please login or signup'
      end
    end

    # view input
    delegate :login, :signup, to: :controller

    def show_profile
      controller.show_profile(user_id: @user_id)
    end
  end

  private_constant :LoginView
end
