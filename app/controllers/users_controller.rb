class UsersController < ApplicationController
  before_action :require_login, except: %i[ new create ]
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      if logged_in?
        redirect_to users_path, notice: "User #{@user.name} was successfully created."
      else
        session[:user_id] = @user.id
        redirect_to users_path, notice: "Welcome! Account created successfully."
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if user_params[:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user != current_user
      @user.destroy!
      redirect_to users_path, notice: "User was successfully destroyed."
    else
      redirect_to users_path, alert: "You cannot delete your own account."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :email, :name, :password, :password_confirmation ])
    end
end
