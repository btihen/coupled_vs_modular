# frozen_string_literal: true

require_relative 'view_driver'

describe 'accounting' do
  let(:view_driver) { ViewDriver.new(Application.instance) }

  def view = view_driver.current_view

  before do
    # Markus buys securities
    view_driver.signup(email: 'm@bla.com', name: 'Markus', country: 'UK')
    view_driver.login(email: 'm@bla.com')
    view_driver.buy(ticker: 'GOOG', quantity: 5)
    view_driver.buy(ticker: 'AMZN', quantity: 10)
    view_driver.logout

    # Elizabeth buys securities
    view_driver.signup(email: 'e@bla.com', name: 'Elizabeth', country: 'UK')
    view_driver.login(email: 'e@bla.com')
    view_driver.buy(ticker: 'AAPL', quantity: 134)
    view_driver.logout

    # Gerold buys securities
    view_driver.signup(email: 'g@bla.com', name: 'Gerold', country: 'DE')
    view_driver.login(email: 'g@bla.com')
    view_driver.buy(ticker: 'AMZN', quantity: 50)
    view_driver.logout
  end

  context 'when user is logged in' do
    before { view_driver.login(email: 'e@bla.com') }

    context 'when user looks at outstanding fees' do
      before { view_driver.show_outstandig_fees }

      it 'shows error', :aggregate_failures do
        expect(view.title).to eq('Uuppss')
        expect(view.content).to eq('404, page not found')
      end
    end
  end

  context 'when admin is logged in' do
    before do
      view_driver.login_admin
      view_driver.show_outstandig_fees
    end

    context 'when admin looks at outstanding fees' do
      it 'shows fees summary', :aggregate_failures do
        expect(view.title).to eq('Outstanding Fees')
        expected_fees = <<~FEES
          Fees:
            133.50 EUR
            139.20 GBP
          Total:
            324.00 USD
        FEES
                        .chomp
        expect(view.content).to eq(expected_fees)
      end
    end
  end
end
