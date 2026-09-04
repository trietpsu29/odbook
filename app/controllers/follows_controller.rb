class FollowsController < ApplicationController
  before_action :set_follow
  before_action :authorize_follow
  def destroy
    if @follow.destroy
      redirect_to users_path
    else
      redirect_to users_path, alert: @follow.errors.full_messages.join("\n")
    end
  end
private
  def set_follow
    @follow = Follow.find(params[:id])
  end

  def authorize_follow
    return if @follow.follower==current_user || @follow.followed==current_user
    redirect_to users_path, alert: "You are not authorized to do that."
  end
end
