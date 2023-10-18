# frozen_string_literal: true

class AdminView < View
  # view content
  def title = 'Administrator dashboard'

  def content
    @users.select { _1.person.present? }.map do |user|
      person = user.person
      version_dates = person.version_dates
      (
        ["#{user.email}:"] +
        version_dates.map do |date|
          name = person.name_on(date)
          address = person.address.on(date)
          "  #{name}, #{address.street}, #{address.zip} #{address.city}, #{address.country}"
        end
      ).join("\n")
    end.join("\n")
  end

  # view input
  delegate :generate_passcode, :show_outstandig_fees, to: :controller
end
