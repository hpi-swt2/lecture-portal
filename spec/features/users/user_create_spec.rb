require "rails_helper"

describe "Creating a new user", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  before :each do
    @email_lecturer = "lecturer@mail.com"
    @email_student = "student@mail.com"
    @password="12345678"
    @real_secret_key = "abcde"
    @wrong_secret_key= "aaaa"
    @blank_secret_key= ""
  end

  context "secret key is set" do
      before :each do
        allow(ENV).to receive(:fetch).with("SECRET_KEY", User.secret_key_default).and_return(@real_secret_key)
      end

      it "makes a user who knows the secret key a lecturer" do
        visit(new_user_registration_path)
        find(:id, "user_email").set(@email_lecturer)
        find(:id, "user_password").set(@password)
        find(:id, "user_password_confirmation").set(@password)
        find(:id, "user_secret_key").set(@real_secret_key)
        click_on("Sign up")
        expect(User.find_by email: @email_lecturer).to_not be_nil
        expect(User.find_by_email(@email_lecturer).is_student).to_not be_truthy
      end

      it "does not make a user who does not know the secret key a lecturer" do
          visit(new_user_registration_path)
          find(:id, "user_email").set(@email_student)
          find(:id, "user_password").set(@password)
          find(:id, "user_password_confirmation").set(@password)
          find(:id, "user_secret_key").set(@wrong_secret_key)
          click_on("Sign up")
          user = User.find_by email: @email_student
          expect(user).to_not be_nil
          expect(user.is_student).to be_truthy
        end

      it "does not make a user who does not know the secret key a lecturer" do
        visit(new_user_registration_path)
        find(:id, "user_email").set(@email_student)
        find(:id, "user_password").set(@password)
        find(:id, "user_password_confirmation").set(@password)
        find(:id, "user_secret_key").set(@blank_secret_key)
        click_on("Sign up")
        user = User.find_by email: @email_student
        expect(user).to_not be_nil
        expect(user.is_student).to be_truthy
      end
    end

  context "secret key is not set" do
    before :each do
      allow(ENV).to receive(:fetch).with("SECRET_KEY", User.secret_key_default).and_return(User.secret_key_default)
    end

    it "makes a user who knows the secret key a lecturer" do
      visit(new_user_registration_path)
      find(:id, "user_email").set(@email_lecturer)
      find(:id, "user_password").set(@password)
      find(:id, "user_password_confirmation").set(@password)
      find(:id, "user_secret_key").set(User.secret_key_default)
      click_on("Sign up")
      expect(User.find_by email: @email_lecturer).to_not be_nil
      expect(User.find_by_email(@email_lecturer).is_student).to_not be_truthy
    end

    it "does not make a user who does not know the secret key a lecturer" do
        visit(new_user_registration_path)
        find(:id, "user_email").set(@email_student)
        find(:id, "user_password").set(@password)
        find(:id, "user_password_confirmation").set(@password)
        find(:id, "user_secret_key").set(@wrong_secret_key)
        click_on("Sign up")
        user = User.find_by email: @email_student
        expect(user).to_not be_nil
        expect(user.is_student).to be_truthy
      end

    it "does not make a user who uses a blank secret key a lecturer" do
      visit(new_user_registration_path)
      find(:id, "user_email").set(@email_student)
      find(:id, "user_password").set(@password)
      find(:id, "user_password_confirmation").set(@password)
      find(:id, "user_secret_key").set(@blank_secret_key)
      click_on("Sign up")
      user = User.find_by email: @email_student
      expect(user).to_not be_nil
      expect(user.is_student).to be_truthy
    end
  end
end
