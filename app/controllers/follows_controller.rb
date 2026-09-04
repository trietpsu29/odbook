class FollowsController < ApplicationController
  before_action :set_follow
  before_action :authorize_follow
  def destroy
    if @follow.destroy
      respond_to do |format|
        format.turbo_stream do
          render "shared/update_follow_button",
          locals: { user: @follow.followed }
        end
        format.html do
          redirect_to users_path
        end
      end
    else
      redirect_to users_path, alert: @follow.errors.full_messages.join("\n")
      respond_to do |format|
        flash.now[:alert] = @follow.errors.full_messages.join("\n")

        format.turbo_stream do
          render "shared/update_follow_button",
            locals: { user: user },
            status: :unprocessable_entity
        end

        format.html do
          redirect_to users_path,
            alert: @follow.errors.full_messages.join("\n"),
            status: :unprocessable_entity
        end
      end
    end
  end
private
  def set_follow
    @follow = Follow.find(params[:id])
  end

  def authorize_follow
    return if @follow.follower==current_user || @follow.followed==current_user
    respond_to do |format|
        flash.now[:alert] = @follow.errors.full_messages.join("\n")

        format.turbo_stream do
          render "shared/update_follow_button",
            locals: { user: user },
            status: :unprocessable_entity
        end

        format.html do
          redirect_to users_path,
            alert: @follow.errors.full_messages.join("\n"),
            status: :unprocessable_entity
        end
      end
  end
end
