# frozen_string_literal: true

# Helps automating interactions with the Application/Views
class ViewDriver
  def initialize(app)
    @app = app
    @app.load
  end

  DEFAULT_PWD = '12345:-)'
  DEFAULT_EMAIL = 'mark@liamtoh.com'
  private_constant :DEFAULT_PWD, :DEFAULT_EMAIL

  delegate :generate_passcode,
           :logout,
           :show_profile,
           :buy,
           :show_investment_news,
           :show_investment_fees,
           :show_outstandig_fees,
           :change_name_to,
           :change_address_to, to: :current_view

  def current_view = @app.current_view

  def signup(password: DEFAULT_PWD,
             passcode: nil,
             street: 'Baumweg 13',
             country: 'CH',
             email: DEFAULT_EMAIL,
             name: 'Mark',
             zip: '3001',
             city: 'Bern')
    current_view.signup(email:, password:, passcode:, name:, street:, zip:, city:, country:)
  end

  def login(email: 'mark@liamtoh.com', password: DEFAULT_PWD)
    current_view.login(email:, password:)
  end

  def signup_mark(password: DEFAULT_PWD, country: 'CH', street: 'Baumweg 13', passcode: nil)
    current_view.signup(email: DEFAULT_EMAIL,
                        password:,
                        passcode:,
                        name: 'Mark',
                        street:,
                        zip: '3001',
                        city: 'Bern',
                        country:)
  end

  def login_mark(password: DEFAULT_PWD) = current_view.login(email: 'mark@liamtoh.com', password:)

  def login_admin = current_view.login(email: 'admin@messy.com', password: '&£78fsasd')
end
