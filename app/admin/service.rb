# frozen_string_literal: true

module Admin
  # The Admin-API. Provides public access to the module.
  class Service
    class << self
      delegate :seed_data, :find_user, :find_user_and_country, to: :repository

      private

      def repository = Repository
    end
  end
end
