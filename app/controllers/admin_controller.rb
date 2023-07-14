# frozen_string_literal: true

class AdminController < ApplicationController
  def show(*)
    @users = User.all
    render(AdminView)
  end

  def generate_passcode(name:, street:, zip:, city:, country:)
    @name = name
    @passcode = rand(100_000..999_999)

    Passcode.create(name:, street:, zip:, city:, country:, passcode: @passcode)

    render(PasscodeView)
  end

  def show_outstandig_fees
    redirect_to(AccountingController)
  end
end
