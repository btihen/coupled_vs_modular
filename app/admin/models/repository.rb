# frozen_string_literal: true

module Admin
  class Repository
    # A default Admin. Doesn't have a person associated.
    DefaultUserData = Data.define(:id, :email, :admin?)
    # A User or Admin. Does have a person associated.
    UserData = Data.define(:id, :email, :name, :admin?, :street, :zip, :city, :country)
    # A Country with its User-Ids.
    CountryData = Data.define(:user_id, :country)
    # The Base-Query to fetchint a User with its Person and Address.
    UserDataQuery = User.includes(person: :address)

    private_constant :UserData, :DefaultUserData, :UserDataQuery

    class << self
      def seed_data
        User.create(email: 'admin@messy.com', password: '&£78fsasd', is_admin: true, person_id: nil)
      end

      def find_user(user_id)
        user = UserDataQuery.find(user_id)
        return nil unless user.present?

        map_user_data(user)
      end

      def find_user_by(**)
        user = UserDataQuery.find_by(**)
        return nil unless user.present?

        map_user_data(user)
      end

      def find_all_users = UserDataQuery.all.map { map_user_data(_1) }

      def find_user_and_country
        User.joins(person: :address).pluck(:id, 'addresses.country').map do |user_id, country|
          CountryData.new(user_id:, country:)
        end
      end

      def passcode_exists?(details:, passcode:)
        details => {name:, street:, city:, zip:, country:}
        Passcode.exists?(name:, street:, zip:, city:, country:, passcode:)
      end

      private

      def map_user_data(user)
        user.person.present? ? create_user_data(user) : create_default_user_data(user)
      end

      def create_user_data(user)
        person = user.person
        address = user.person.address

        UserData.new(id: user.id,
                     email: user.email,
                     admin?: user.admin?,
                     name: person.name,
                     street: address.street,
                     zip: address.zip,
                     city: address.city,
                     country: address.country)
      end

      def create_default_user_data(user)
        DefaultUserData.new(id: user.id,
                            email: user.email,
                            admin?: user.admin?)
      end
    end
  end

  private_constant :Repository
end
