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
    # address = Address.create
    # address.address_versions.create(
    #   street:, city:, zip:, country:, valid_from: Time.now
    # )
    # person = Person.create(address:)
    # person.name_versions.create(name:, valid_from: Time.now)

    # @user = User.new(email:, password:, person:)
    @user = build_user(email:, password:, name:, street:, zip:, city:, country:) # rubocop:disable Metrics/LineLength

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

  def build_user(email:, password:, name:, street:, zip:, city:, country:) # rubocop:disable Metrics/ParameterLists
    address = Address.create
    address.address_versions.create(
      street:, city:, zip:, country:, valid_from: Date.today
    )
    person = Person.create(address:)
    person.name_versions.create(name:, valid_from: Date.today)

    User.new(email:, password:, person:)
  end

  def redirect(_user)
    if @user.admin?
      redirect_to(AdminController, user_id: @user.id)
    else
      redirect_to(PortfolioController, user_id: @user.id)
    end
  end
end
