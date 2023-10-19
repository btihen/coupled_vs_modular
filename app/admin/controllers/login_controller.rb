# frozen_string_literal: true

module Admin
  class LoginController < Common::ApplicationController
    Login = Data.define(:email, :password)
    Details = Data.define(:name, :street, :zip, :city, :country)

    def show
      render(LoginView)
    end

    def login(login:)
      login => {email:, password:}

      @user = Repository.find_user_by(email:, password:)
      if @user.present?
        redirect(@user)
      else
        @login_failed = true
        render(LoginView)
      end
    end

    def signup(login:, details:, passcode:)
      user = create_user(login:, details:)

      case try_signup(user:, details:, passcode:)
      when :ok
        @user = user
      when :passcode_failed
        @passcode_failed = true
      end

      render(SignupResultView)
    end

    def show_profile(user_id:)
      redirect_to(ProfileController, user_id:)
    end

    private

    def create_user(login:, details:)
      login => {email:, password:}
      details => {name:, street:, city:, zip:, country:}

      address = Address.create
      person = Person.create(address:)
      AddressVersion.create(
        address:, street:, city:, zip:, country:, valid_from: Time.now
      )
      NameVersion.create(person:, name:, valid_from: Time.now)

      @user = User.new(email:, password:, person:)
    end

    def try_signup(user:, details:, passcode:)
      if passcode.present?
        try_signup_admin(user:, details:, passcode:)
      else
        user.save
        :ok
      end
    end

    def try_signup_admin(user:, details:, passcode:)
      details => {name:, street:, city:, zip:, country:}

      if Repository.passcode_exists?(details:, passcode:)
        user.is_admin = true
        user.save
        :ok
      else
        :passcode_failed
      end
    end

    def redirect(_user)
      if @user.admin?
        redirect_to(AdminController, user_id: @user.id)
      else
        redirect_to(Securities::PortfolioController, user_id: @user.id)
      end
    end
  end
end
