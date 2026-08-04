# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < BaseController
      # GET /api/v1/users
      def index
        users = User.all.map { |u| user_payload(u) }
        render json: users, status: :ok
      end

      # GET /api/v1/users/:id
      def show
        user = User.find(params[:id])
        render json: user_payload(user), status: :ok
      end

      # POST /api/v1/users
      def create
        user = User.new(user_params)

        if user.save
          render json: user_payload(user), status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_content
        end
      end

      # PUT/PATCH /api/v1/users/:id
      def update
        user = User.find(params[:id])

        if user.update(user_params)
          render json: user_payload(user), status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_content
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        user = User.find(params[:id])
        if user != @current_user
          user.destroy!
          render json: { message: "User successfully deleted" }, status: :ok
        else
          render json: { error: "You cannot delete your own account" }, status: :forbidden
        end
      end

      private

      def user_params
        params.permit(:email, :name, :password)
      end

      def user_payload(user)
        { id: user.id, email: user.email, name: user.name, created_at: user.created_at }
      end
    end
  end
end
