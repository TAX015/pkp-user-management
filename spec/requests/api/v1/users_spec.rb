require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let!(:current_user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:valid_token) { JsonWebToken.encode(user_id: current_user.id) }
  let(:headers) { { "Authorization" => "Bearer #{valid_token}" } }

  describe "Authentication Check (BaseController)" do
    it "rejects requests without Authorization header" do
      get "/api/v1/users"

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Unauthorized: Invalid or missing token")
    end

    it "rejects requests with malformed/expired JWT token" do
      get "/api/v1/users", headers: { "Authorization" => "Bearer invalid.token.value" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/users" do
    it "returns list of all users" do
      get "/api/v1/users", headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
      expect(json.map { |u| u["id"] }).to include(current_user.id, other_user.id)
    end
  end

  describe "GET /api/v1/users/:id" do
    context "when record exists" do
      it "returns user details" do
        get "/api/v1/users/#{other_user.id}", headers: headers

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(other_user.id)
        expect(json["email"]).to eq(other_user.email)
      end
    end

    context "when record does not exist" do
      it "returns 404 not found" do
        get "/api/v1/users/999999", headers: headers

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json["error"]).to include("Couldn't find User")
      end
    end
  end

  describe "POST /api/v1/users" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          email: "created_via_api@example.com",
          name: "Api Created",
          password: "P4ssword!"
        }
      end

      it "creates a new user" do
        expect {
          post "/api/v1/users", params: valid_params, headers: headers
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["email"]).to eq("created_via_api@example.com")
      end
    end

    context "with invalid parameters" do
      it "returns 422 unprocessable content" do
        post "/api/v1/users", params: { email: "bad_email" }, headers: headers

        expect(response).to have_http_status(:unprocessable_content)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "PUT/PATCH /api/v1/users/:id" do
    context "with valid parameters" do
      it "updates the specified user" do
        patch "/api/v1/users/#{other_user.id}", params: { name: "New Api Name" }, headers: headers

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["name"]).to eq("New Api Name")
        expect(other_user.reload.name).to eq("New Api Name")
      end
    end

    context "with invalid parameters" do
      it "returns 422 unprocessable content" do
        patch "/api/v1/users/#{other_user.id}", params: { email: "invalid_email" }, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /api/v1/users/:id" do
    context "deleting another user" do
      it "deletes the user and returns success message" do
        expect {
          delete "/api/v1/users/#{other_user.id}", headers: headers
        }.to change(User, :count).by(-1)

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["message"]).to eq("User successfully deleted")
      end
    end

    context "deleting self" do
      it "prevents deletion and returns 403 forbidden" do
        expect {
          delete "/api/v1/users/#{current_user.id}", headers: headers
        }.not_to change(User, :count)

        expect(response).to have_http_status(:forbidden)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("You cannot delete your own account")
      end
    end
  end
end
