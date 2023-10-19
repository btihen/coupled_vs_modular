# frozen_string_literal: true

module Admin
  class AdminView < View
    # view content
    def title = 'Administrator dashboard'

    def content
      @users.select { _1.respond_to?(:name) }.map do |user|
        user_versions = Repository.user_versions(user.id)
        (
          ["#{user.email}:"] +
          user_versions.map do |uv|
            "  #{uv.name}, #{uv.street}, #{uv.zip} #{uv.city}, #{uv.country}"
          end
        ).join("\n")
      end.join("\n")
    end

    # view input
    delegate :generate_passcode, :show_outstandig_fees, to: :controller
  end

  private_constant :AdminView
end
