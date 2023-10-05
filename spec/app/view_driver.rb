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

  def signup(password: DEFAULT_PWD, # rubocop:disable Metrics/ParameterLists
             passcode: nil,
             street: 'Baumweg 13',
             country: 'CH',
             email: DEFAULT_EMAIL,
             name: 'Mark',
             zip: '3001',
             city: 'Bern')
    login = Admin::LoginController::Login.new(email:, password:)
    details = Admin::LoginController::Details.new(name:, street:, zip:, city:, country:)

    current_view.signup(login:, details:, passcode:)
  end

  def login(email: 'mark@liamtoh.com', password: DEFAULT_PWD)
    login = Admin::LoginController::Login.new(email:, password:)

    current_view.login(login:)
  end

  def signup_mark(password: DEFAULT_PWD, country: 'CH', street: 'Baumweg 13', passcode: nil)
    login = Admin::LoginController::Login.new(email: DEFAULT_EMAIL, password:)
    details = Admin::LoginController::Details.new(name: 'Mark', street:, zip: '3001', city: 'Bern', country:)

    current_view.signup(login:, details:, passcode:)
  end

  def login_mark(password: DEFAULT_PWD)
    login = Admin::LoginController::Login.new(email: 'mark@liamtoh.com', password:)
    current_view.login(login:)
  end

  def login_admin
    login = Admin::LoginController::Login.new(email: 'admin@messy.com', password: '&£78fsasd')
    current_view.login(login:)
  end
end
