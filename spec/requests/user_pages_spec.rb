require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
	  let(:user) { FactoryGirl.create(:user) }
	  before { visit user_path(user) }

	  it { should have_content(user.name) }
	  it { should have_title(user.name) }
  end

  describe "signup" do
	before { visit signup_path }
	let(:submit) { "Create my account" }

	describe "with invalid information" do
		before do 
			fill_in "Name",         with: "Foo Bar"
			fill_in "Email",        with: ""
			fill_in "Password",     with: "foob"
			fill_in "Confirmation", with: ""
			click_button submit
		end
		
        it { should have_title('Sign up') }
        it { should have_content('error') }
        it { should have_content('Email is invalid') }
        it { should have_content('Email can\'t be blank') }
        it { should have_content('Password is too short') }
        it { should have_content('Password confirmation ') }
	end

	describe "with valid information" do
		before do 
			fill_in "Name",         with: "Example User"
			fill_in "Email",        with: "user@example.com"
			fill_in "Password",     with: "foobar"
			fill_in "Confirmation", with: "foobar"
		end
		it "should create a user" do
			expect {click_button submit}.to change(User, :count).by(1)
		end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        
	      describe "followed by signout" do
	        before { click_link "Sign out" }
	        it { should have_link('Sign in') }
	      end
      end

	end

	describe "after saving the user" do
		before do 
			fill_in "Name",         with: "Example User"
			fill_in "Email",        with: "user@example.com"
			fill_in "Password",     with: "foobar"
			fill_in "Confirmation", with: "foobar"
			click_button submit
		end
		it { should have_selector('div.alert.alert-success', text: 'Welcome to the Sample App!') }
	end
  end

end
