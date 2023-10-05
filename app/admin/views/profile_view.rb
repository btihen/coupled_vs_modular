# frozen_string_literal: true

module Admin
  class ProfileView < View
    def title = "#{@user.name}'s profile"

    def content
      <<~PROFILE
        Name: #{@user.name}
        EMail: #{@user.email}
        Address: #{@user.street}, #{@user.zip} #{@user.city}
        Country: #{@user.country}
      PROFILE
    end

    def change_name_to(name:, valid_from:)
      controller.change_name_to(user_id: @user.id, name:, valid_from:)
    end

    def change_address_to(street:, zip:, city:, country:, valid_from:)
      change = ProfileController::AddressChange.new(street:, zip:, city:, country:)
      controller.change_address_to(user_id: @user.id, change:, valid_from:)
    end

    def show_portfolio
      controller.show_portfolio(user_id: @user.id)
    end

    def show_investment_news
      controller.show_investment_news(user_id: @user.id)
    end

    def show_investment_fees
      controller.show_investment_fees(user_id: @user.id)
    end
  end

  private_constant :ProfileView
end
