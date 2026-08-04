require 'rails_helper'

RSpec.describe "Api::V1::Authentications", type: :request do
  let!(:user) { create(:user, email: "api_user@example.com", password: "P4ssword!", name: "Api User") }

  describe "POST /api/v1/register" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          email: "new_api_user@example.com",
          name: "New User",
          password: "P4ssword!"
        }
      end

      it "creates a new user and returns a JWT token with user payload" do
        expect {
          post "/api/v1/register", params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["token"]).to be_present
        expect(json["user"]["email"]).to eq("new_api_user@example.com")
        expect(json["user"]["name"]).to eq("New User")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          email: "invalid_email",
          name: "",
          password: "short"
        }
      end

      it "returns 422 unprocessable entity with error messages" do
        expect {
          post "/api/v1/register", params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "POST /api/v1/login" do
    context "with valid credentials" do
      it "returns a JWT token and user payload" do
        post "/api/v1/login", params: { email: "api_user@example.com", password: "P4ssword!" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["token"]).to be_present
        expect(json["user"]["id"]).to eq(user.id)
        expect(json["user"]["email"]).to eq(user.email)
      end
    end

    context "with invalid credentials" do
      it "returns 401 unauthorized with error message when password is wrong" do
        post "/api/v1/login", params: { email: "api_user@example.com", password: "WrongPassword1!" }

        expect(response).to have_http_status(:unauthorized)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Invalid email or password")
      end

      it "returns 401 unauthorized when user does not exist" do
        post "/api/v1/login", params: { email: "nobody@example.com", password: "P4ssword!" }

        expect(response).to have_http_status(:unauthorized)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "GET /api/v1/current_user" do
    context "when authenticated" do
      it "returns details of the authenticated user" do
        token = JsonWebToken.encode(user_id: user.id)

        get "/api/v1/current_user", headers: { "Authorization" => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(user.id)
        expect(json["email"]).to eq(user.email)
      end
    end

    context "when unauthenticated" do
      it "returns 401 unauthorized" do
        get "/api/v1/current_user"

        expect(response).to have_http_status(:unauthorized)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Unauthorized: Invalid or missing token")
      end
    end
  end
end
