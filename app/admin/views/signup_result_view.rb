# frozen_string_literal: true

module Admin
  class SignupResultView < View
    # view content
    def title = 'Messy App'

    def content
      if @passcode_failed
        'Passcode incorrect. Please try again or request a new one.'
      else
        'Thanks for signing up. Please login now.'
      end
    end

    # view input
    delegate :login, :signup, to: :controller

    def show_profile
      controller.show_profile(user_id: @user_id)
    end
  end

  private_constant :SignupResultView
end
