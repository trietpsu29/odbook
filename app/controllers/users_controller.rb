class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy, :show ]
  before_action :authorize_user, only: [ :edit, :update, :destroy ]
  layout "authenticated"

  def index
    case params[:filter]
    when "following"
      @users = current_user.following

    when "followers"
      @users = current_user.followers

    when "requests"
      @users = current_user.requesting_users

    when "requested"
      @users = current_user.requested_users

    else
      @users = User.all
    end

    @users = @users.includes(avatar_attachment: :blob)
  end

  def show
    @posts = Post.includes(:user, images_attachments: :blob)
    .where(user: @user)
    .order(created_at: :desc)
  end

  def edit
  end

  def update
    if params[:remove_avatar] == "1"
      @user.avatar.purge
    end

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profile updated successfully!"
    else
      flash.now[:alert] = @user.errors.full_messages.join("\n")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path
    else
      redirect_to user_path(@user), alert: @user.errors.full_messages.join("\n")
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
