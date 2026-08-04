# app/controllers/api/v1/authentication_controller.rb
module Api
  module V1
    class AuthenticationController < BaseController
      skip_before_action :authenticate_api_user!, only: %i[login register]

      # POST /api/v1/register
      def register
        user = User.new(register_params)

        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token, user: user_payload(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_content
        end
      end

      # POST /api/v1/login
      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token, user: user_payload(user) }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      # GET /api/v1/current_user
      def current_user
        render json: user_payload(@current_user), status: :ok
      end

      private

      def register_params
        params.permit(:email, :name, :password)
      end

      def user_payload(user)
        { id: user.id, email: user.email, name: user.name, created_at: user.created_at }
      end
    end
  end
end
