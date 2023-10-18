# frozen_string_literal: true

class ProfileView < View
  def title = "#{@user.person.name_on(Date.today)}'s profile"

  def content
    person = @user.person
    address = person.address.on(Date.today)
    <<~PROFILE
      Name: #{person.name_on(Date.today)}
      EMail: #{@user.email}
      Address: #{address.street}, #{address.zip} #{address.city}
      Country: #{address.country}
    PROFILE
  end

  def change_name_to(name:, valid_from:)
    controller.change_name_to(user_id: @user.id, name:, valid_from:)
  end

  def change_address_to(street:, zip:, city:, country:, valid_from:)
    controller.change_address_to(user_id: @user.id, street:, zip:, city:, country:, valid_from:)
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
