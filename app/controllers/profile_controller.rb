# frozen_string_literal: true

class ProfileController < ApplicationController
  def show(user_id:)
    @user = User.find(user_id)

    render(ProfileView)
  end

  def change_name_to(user_id:, name:, valid_from:)
    @user = User.find(user_id)

    @user.person.name = name
    @user.save

    render(ProfileView)
  end

  def change_address_to(user_id:, street:, zip:, city:, country:, valid_from:)
    @user = User.find(user_id)

    @user.person.address.street = street
    @user.person.address.zip = zip
    @user.person.address.city = city
    @user.person.address.country = country
    @user.save

    render(ProfileView)
  end

  def show_portfolio(user_id:)
    redirect_to(PortfolioController, user_id:)
  end

  def show_investment_news(user_id:)
    redirect_to(InvestmentNewsController, user_id:)
  end

  def show_investment_fees(user_id:)
    redirect_to(InvestmentFeesController, user_id:)
  end
end
