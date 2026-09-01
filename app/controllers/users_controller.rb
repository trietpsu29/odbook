class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy, :show ]
  before_action :authorize_user, only: [ :edit, :update, :destroy ]
  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Something went wrong"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path
    else
      redirect_to user_path(@user), alert: "Something went wrong"
    end
  end

  private

    def user_params
      params.expect(user: [ :name, :bio, :avatar ])
    end

    def authorize_user
      return if @user == current_user

      redirect_to users_path, alert: "You are not authorized to do that."
    end

    def set_user
      @user = User.find(params[:id])
    end
end
