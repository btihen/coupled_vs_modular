# frozen_string_literal: true

module Admin
  class ProfileController < Common::ApplicationController
    AddressChange = Data.define(:street, :zip, :city, :country)

    def show(user_id:)
      @user = Repository.find_user(user_id)

      render(ProfileView)
    end

    def change_name_to(user_id:, name:, valid_from:)
      change_user(user_id) do |user|
        user.person.name = name
      end
    end

    def change_address_to(user_id:, change:, valid_from:)
      change_user(user_id) do |user|
        change => { street:, zip:, city:, country: }
        user.person.address.street = street
        user.person.address.zip = zip
        user.person.address.city = city
        user.person.address.country = country
      end
    end

    def show_portfolio(user_id:)
      redirect_to(Securities::PortfolioController, user_id:)
    end

    def show_investment_news(user_id:)
      redirect_to(Securities::InvestmentNewsController, user_id:)
    end

    def show_investment_fees(user_id:)
      redirect_to(Securities::InvestmentFeesController, user_id:)
    end

    private

    def change_user(user_id)
      user = User.find(user_id)
      yield(user)

      user.save

      @user = Repository.find_user(user_id)
      render(ProfileView)
    end
  end
end
