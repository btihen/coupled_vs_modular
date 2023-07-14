# frozen_string_literal: true

require_relative 'view_driver'

describe 'user securites dealing' do
  let(:view_driver) { ViewDriver.new(Application.instance) }
  let(:country) { 'DE' }
  let(:today) { Date.new(2023, 5, 30) }

  def view = view_driver.current_view

  before do
    Timecop.travel(today)
    view_driver.signup_mark(country:)
    view_driver.login_mark
  end

  context 'when user is logged in' do
    it 'show portfolio summary to user', :aggregate_failures do
      expect(view.title).to eq("Mark's portfolio")
      expect(view.content).to eq('Mark, your portfolio is worth nothing')
    end
  end

  context 'when user buys a stock' do
    before { view_driver.buy(ticker: 'AAPL', quantity: 45) }

    context 'when user lives in Switzerland' do
      let(:country) { 'CH' }

      it 'updates portfolio summary', :aggregate_failures do
        expect(view.content).to eq('Mark, your portfolio is worth 4365.00 CHF')
      end
    end

    context 'when user lives in the US' do
      let(:country) { 'US' }

      it 'updates portfolio summary', :aggregate_failures do
        expect(view.content).to eq('Mark, your portfolio is worth 4500.00 USD')
      end
    end
  end

  context 'when user looks at investment news' do
    context 'when user lives in Germany' do
      let(:country) { 'DE' }

      before { view_driver.show_investment_news }

      it 'shows news', :aggregate_failures do
        expect(view.title).to eq("Mark's news")
        expect(view.content).to eq('Exchange Rate USD/EUR: 0.89')
      end
    end

    context 'when user lives in Switzerland' do
      let(:country) { 'CH' }

      before { view_driver.show_investment_news }

      it 'shows news', :aggregate_failures do
        expect(view.title).to eq("Mark's news")
        expect(view.content).to eq('Exchange Rate USD/CHF: 0.97')
      end
    end
  end

  context 'when user looks at fees' do
    context 'when user has not boutght any securities' do
      it 'shows no fees', :aggregate_failures do
        view_driver.show_investment_fees

        expect(view.title).to eq("Mark's fees (in EUR)")
        expect(view.content).to eq('there are no fees')
      end
    end

    context 'when user has bough securities' do
      before { view_driver.buy(ticker: 'AAPL', quantity: 45) }

      context 'when user lives in US' do
        let(:country) { 'US' }

        it 'shows fees', :aggregate_failures do
          view_driver.show_investment_fees

          expect(view.title).to eq("Mark's fees (in USD)")
          expect(view.content).to eq('Fees: 45.00 USD')
        end
      end

      context 'when user lives in Germany' do
        let(:country) { 'DE' }

        it 'shows fees', :aggregate_failures do
          view_driver.show_investment_fees

          expect(view.title).to eq("Mark's fees (in EUR)")
          expect(view.content).to eq('Fees: 40.05 EUR')
        end
      end
    end
  end
end
