# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_user!

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

      def authenticate_api_user!
        header = request.headers["Authorization"]
        token = header.split(" ").last if header.present?
        decoded = JsonWebToken.decode(token) if token

        if decoded && (@current_user = User.find_by(id: decoded[:user_id]))
          @current_user
        else
          render json: { error: "Unauthorized: Invalid or missing token" }, status: :unauthorized
        end
      end

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_content
      end
    end
  end
end
