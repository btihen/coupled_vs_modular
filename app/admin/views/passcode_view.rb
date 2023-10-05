# frozen_string_literal: true

module Admin
  class PasscodeView < View
    # view content
    def title = 'Administrator dashboard'

    def content
      "Passcode for #{@name} is #{@passcode}"
    end
  end

  private_constant :PasscodeView
end
