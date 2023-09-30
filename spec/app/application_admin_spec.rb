# frozen_string_literal: true

require_relative 'view_driver'

describe 'user administration' do
  let(:view_driver) { ViewDriver.new(Application.instance) }
  let(:today) { Date.new(2023, 7, 8) }

  def view = view_driver.current_view

  before { Timecop.travel(today) }

  context 'when user opens app' do
    it 'shows login view', :aggregate_failures do
      expect(view.title).to eq('Messy App')
      expect(view.content).to eq('Please login or signup')
    end
  end

  context 'when admin generates passcode' do
    before do
      view_driver.login_admin
      view_driver.generate_passcode(name: 'Mark',
                                    street: 'Baumweg 13',
                                    zip: '3001',
                                    city: 'Bern',
                                    country: 'CH')
    end

    it 'shows generated passcode' do
      expect(view.title).to eq('Administrator dashboard')
      expect(view.content).to match(/Passcode for Mark is \d+/)
    end
  end

  context 'when user signs up' do
    context 'with normal user' do
      before { view_driver.signup_mark(password: '12345:-)') }

      it 'shows signup successful', :aggregate_failures do
        expect(view.title).to eq('Messy App')
        expect(view.content).to eq('Thanks for signing up. Please login now.')
      end

      it "shows user information on user's profile" do
        view_driver.login_mark
        view_driver.show_profile

        expect(view.title).to eq("Mark's profile")
        expected_profile = <<~PROFILE
          Name: Mark
          EMail: mark@liamtoh.com
          Address: Baumweg 13, 3001 Bern
          Country: CH
        PROFILE
        expect(view.content).to eq(expected_profile)
      end
    end

    context 'with new admin user' do
      before do
        view_driver.login_admin
        view_driver.generate_passcode(name: 'Mark',
                                      street: 'Baumweg 13',
                                      zip: '3001',
                                      city: 'Bern',
                                      country: 'CH')
      end

      context 'when passcode correct' do
        before do
          # copy generated passcode and give signing up user
          view.content =~ /\d+$/
          passcode = Regexp.last_match(0)

          view_driver.logout

          # user signs up with generated passcode
          view_driver.signup_mark(passcode:, street:)
        end

        context 'when address details correct' do
          let(:street) { 'Baumweg 13' }

          it 'shows signup successfull', :aggregate_failures do
            expect(view.title).to eq('Messy App')
            expect(view.content).to eq('Thanks for signing up. Please login now.')
          end
        end

        context 'when address details incorrect' do
          let(:street) { 'Lowmatt 7a' }

          it 'shows passcode incorrect', :aggregate_failures do
            expect(view.title).to eq('Messy App')
            expect(view.content).to eq('Passcode incorrect. Please try again or request a new one.')
          end
        end

        context 'when admin user logs in' do
          let(:street) { 'Baumweg 13' }

          before { view_driver.login_mark }

          it 'shows admin dashboard', :aggregate_failures do
            expect(view.title).to eq('Administrator dashboard')
            expected_content = <<~USERS
              mark@liamtoh.com:
                Mark, Baumweg 13, 3001 Bern, CH
            USERS
            expect(view.content).to eq(expected_content.strip)
          end
        end
      end

      describe 'when passcode incorrect' do
        before do
          view_driver.logout

          view_driver.signup_mark(passcode: 'incorrect passcode')
        end

        it 'shows signup failed', :aggregate_failures do
          expect(view.title).to eq('Messy App')
          expect(view.content).to eq('Passcode incorrect. Please try again or request a new one.')
        end
      end
    end

    context 'with several users' do
      before do
        view_driver.signup(email: 'jeremy@liamtoh.com',
                           password: '288$L',
                           passcode: nil,
                           name: 'Jeremy',
                           street: 'Obere Matte 2',
                           zip: '70173',
                           city: 'Stuttgart',
                           country: 'DE')
        view_driver.signup(email: 'susanne@liamtoh.com',
                           password: 'RR$$2',
                           passcode: nil,
                           name: 'Susanne',
                           street: 'Alpweg 332',
                           zip: '8000',
                           city: 'Zürich',
                           country: 'CH')
      end

      it 'shows users on Administrator dashboard', :aggregate_failures do
        view_driver.login_admin

        expect(view.title).to eq('Administrator dashboard')

        expected_content = <<~USERS
          jeremy@liamtoh.com:
            Jeremy, Obere Matte 2, 70173 Stuttgart, DE
          susanne@liamtoh.com:
            Susanne, Alpweg 332, 8000 Zürich, CH
        USERS
        expect(view.content).to eq(expected_content.strip)
      end
    end
  end

  context 'when user logs in' do
    context 'when user is admin@messy.com' do
      before { view_driver.login_admin }

      it 'shows admin dashboard', :aggregate_failures do
        expect(view.title).to eq('Administrator dashboard')
        expect(view.content).to eq('')
      end
    end

    context 'when user has signed up' do
      before { view_driver.signup_mark(password: '12345:-)') }

      context 'when invalid password provided' do
        before { view_driver.login_mark(password: 'R$$*"_dfg') }

        it 'shows error to user', :aggregate_failures do
          expect(view.title).to eq('Messy App')
          expect(view.content).to eq('Username or password is invalid')
        end
      end
    end

    context "when user hasn't signed up" do
      before { view_driver.login_mark }

      it 'shows error to user', :aggregate_failures do
        expect(view.title).to eq('Messy App')
        expect(view.content).to eq('Username or password is invalid')
      end
    end
  end

  context 'when user logs out' do
    before do
      view_driver.login_admin
      view_driver.logout
    end

    it 'shows login screen' do
      expect(view.title).to eq('Messy App')
      expect(view.content).to eq('Please login or signup')
    end
  end

  context "when user changes it's profile" do
    before do
      view_driver.signup(name: 'John',
                         email: 'john@liamtoh.com',
                         street: '12 Bow Lane',
                         zip: 'BD12 4LL',
                         city: 'Bradford',
                         country: 'UK')
      view_driver.login(email: 'john@liamtoh.com')
    end

    context 'when user changes name' do
      let(:valid_from) { today + 1.month }

      before do
        view_driver.show_profile
        view_driver.change_name_to(name: 'Johnny', valid_from:)
        view_driver.logout
        view_driver.login(email: 'john@liamtoh.com')
      end

      context 'when changed name is not valid yet' do
        before { Timecop.travel(valid_from - 1.day) }

        it 'shows old name in the profile', :aggregate_failures do
          view_driver.show_profile

          expect(view.title).to eq("John's profile")
          expected_profile = <<~PROFILE
            Name: John
            EMail: john@liamtoh.com
            Address: 12 Bow Lane, BD12 4LL Bradford
            Country: UK
          PROFILE
          expect(view.content).to eq(expected_profile)
        end
      end

      context 'when changed name is already valid' do
        before { Timecop.travel(valid_from) }

        it 'shows changed name in the profile', :aggregate_failures do
          view_driver.show_profile

          expect(view.title).to eq("Johnny's profile")
          expected_profile = <<~PROFILE
            Name: Johnny
            EMail: john@liamtoh.com
            Address: 12 Bow Lane, BD12 4LL Bradford
            Country: UK
          PROFILE
          expect(view.content).to eq(expected_profile)
        end
      end

      context 'when admin user logs in' do
        before do
          view_driver.logout
          view_driver.login_admin
        end

        it 'shows admin dashboard with updated user info', :aggregate_failures do
          expect(view.title).to eq('Administrator dashboard')
          expected_content = <<~USERS
            john@liamtoh.com:
              John, 12 Bow Lane, BD12 4LL Bradford, UK
              Johnny, 12 Bow Lane, BD12 4LL Bradford, UK
          USERS
          expect(view.content).to eq(expected_content.strip)
        end
      end
    end

    context 'when user changes address' do
      let(:valid_from) { today + 1.year }

      before do
        view_driver.show_profile
        view_driver.change_address_to(street: '113c Upper Street',
                                      zip: 'NX1 1LY',
                                      city: 'Norwich',
                                      country: 'UK',
                                      valid_from:)
        view_driver.logout
        view_driver.login(email: 'john@liamtoh.com')
      end

      context 'when changed address is not valid yet' do
        before { Timecop.travel(valid_from - 1.day) }

        it 'shows old address in the profile', :aggregate_failures do
          view_driver.show_profile

          expect(view.title).to eq("John's profile")
          expected_profile = <<~PROFILE
            Name: John
            EMail: john@liamtoh.com
            Address: 12 Bow Lane, BD12 4LL Bradford
            Country: UK
          PROFILE
          expect(view.content).to eq(expected_profile)
        end
      end

      context 'when changed address is already valid' do
        before { Timecop.travel(valid_from) }

        it 'shows old address in the profile', :aggregate_failures do
          view_driver.show_profile

          expect(view.title).to eq("John's profile")
          expected_profile = <<~PROFILE
            Name: John
            EMail: john@liamtoh.com
            Address: 113c Upper Street, NX1 1LY Norwich
            Country: UK
          PROFILE
          expect(view.content).to eq(expected_profile)
        end
      end

      context 'when admin user logs in' do
        before do
          view_driver.logout
          view_driver.login_admin
        end

        it 'shows admin dashboard with updated user info', :aggregate_failures do
          expect(view.title).to eq('Administrator dashboard')
          expected_content = <<~USERS
            john@liamtoh.com:
              John, 12 Bow Lane, BD12 4LL Bradford, UK
              John, 113c Upper Street, NX1 1LY Norwich, UK
          USERS
          expect(view.content).to eq(expected_content.strip)
        end
      end
    end

    context 'when user changes address and name several times' do
      before do
        view_driver.show_profile
        view_driver.change_address_to(street: '113c Upper Street', zip: 'NX1 1LY', city: 'Norwich', country: 'UK',
                                      valid_from: today + 1.year)
        view_driver.change_address_to(street: '113c Upper Road', zip: 'NX1 1LY', city: 'Norwich', country: 'UK',
                                      valid_from: today + 2.years)
        view_driver.change_name_to(name: 'Johnny', valid_from: today + 3.years)
        view_driver.change_address_to(street: '12 Llyelyn Road', zip: 'CF10 2GP', city: 'Cardiff', country: 'UK',
                                      valid_from: today + 4.years)
        view_driver.change_name_to(name: 'John', valid_from: today + 5.years)
      end

      context 'when some changes are already valid' do
        before do
          Timecop.travel(today + 3.years)
          view_driver.logout
          view_driver.login(email: 'john@liamtoh.com')
        end

        it 'shows changes in the profile', :aggregate_failures do
          view_driver.show_profile

          expect(view.title).to eq("Johnny's profile")
          expected_profile = <<~PROFILE
            Name: Johnny
            EMail: john@liamtoh.com
            Address: 113c Upper Road, NX1 1LY Norwich
            Country: UK
          PROFILE
          expect(view.content).to eq(expected_profile)
        end
      end

      context 'when admin user logs in' do
        before do
          view_driver.logout
          view_driver.login_admin
        end

        it 'shows admin dashboard with updated user info', :aggregate_failures do
          expect(view.title).to eq('Administrator dashboard')
          expected_content = <<~USERS
            john@liamtoh.com:
              John, 12 Bow Lane, BD12 4LL Bradford, UK
              John, 113c Upper Street, NX1 1LY Norwich, UK
              John, 113c Upper Road, NX1 1LY Norwich, UK
              Johnny, 113c Upper Road, NX1 1LY Norwich, UK
              Johnny, 12 Llyelyn Road, CF10 2GP Cardiff, UK
              John, 12 Llyelyn Road, CF10 2GP Cardiff, UK
          USERS
          expect(view.content).to eq(expected_content.strip)
        end
      end
    end
  end
end
