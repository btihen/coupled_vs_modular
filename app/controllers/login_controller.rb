# frozen_string_literal: true

class LoginController < ApplicationController
  def show
    render(LoginView)
  end

  def login(email:, password:)
    @user = User.find_by(email:, password:)
    if @user.present?
      redirect(@user)
    else
      @login_failed = true
      render(LoginView)
    end
  end

  def signup(email:, password:, passcode:, name:, street:, zip:, city:, country:) # rubocop:disable Metrics/ParameterLists
    address = Address.new(street:, city:, zip:, country:)
    person = Person.new(name:, address:)
    @user  = User.new(email:, password:, person:)

    if passcode.present?
      passcode = Passcode.find_by(name:, street:, zip:, city:, country:, passcode: passcode.to_i)
      if passcode.present?
        @user.is_admin = true
        @user.save
      else
        @user = nil
        @passcode_failed = true
      end
    else
      @user.save
    end

    render(SignupResultView)
  end

  def show_profile(user_id:)
    redirect_to(ProfileController, user_id:)
  end

  private

  def redirect(_user)
    if @user.admin?
      redirect_to(AdminController, user_id: @user.id)
    else
      redirect_to(PortfolioController, user_id: @user.id)
    end
  end
end
