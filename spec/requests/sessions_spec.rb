require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user, email: "user@example.com", password: "P4ssword!", password_confirmation: "P4ssword!") }

  describe "GET /login (new)" do
    it "renders the login view successfully" do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /login (create)" do
    context "with valid credentials" do
      it "authenticates user, sets session[:user_id], and redirects to users_path" do
        post login_path, params: { email: "user@example.com", password: "P4ssword!" }

        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq("Logged in successfully!")
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "with invalid credentials" do
      it "fails authentication with wrong password and renders :new with 422 status" do
        post login_path, params: { email: "user@example.com", password: "WrongPassword1!" }

        expect(response).to have_http_status(:unprocessable_content)
        expect(flash.now[:alert]).to eq("Invalid email or password")
        expect(session[:user_id]).to be_nil
      end

      it "fails authentication with non-existent email and renders :new with 422 status" do
        post login_path, params: { email: "nonexistent@example.com", password: "P4ssword!" }

        expect(response).to have_http_status(:unprocessable_content)
        expect(flash.now[:alert]).to eq("Invalid email or password")
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe "DELETE /logout (destroy)" do
    before do
      # Simulate logged in state
      post login_path, params: { email: "user@example.com", password: "P4ssword!" }
    end

    it "clears the session[:user_id] and redirects to login_path" do
      expect(session[:user_id]).to eq(user.id)

      delete logout_path

      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq("Logged out successfully!")
      expect(session[:user_id]).to be_nil
    end
  end
end
