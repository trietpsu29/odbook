class FollowRequestsController < ApplicationController
  before_action :set_follow_request, only: [ :destroy, :accept ]

  def create
    @user = User.find(params[:user_id])
    if @user==current_user
      redirect_to users_path, alert: "You cannot follow yourself."
      return
    end

    @follow_request = current_user.sent_follow_requests.build(requested: @user)

    if @follow_request.save
      redirect_to users_path
    else
      redirect_to users_path, alert: "Something went wrong"
    end
  end

  def accept
    if @follow_request.requested != current_user
      redirect_to users_path, alert: "You cannot perform this action."
      return
    end
    Follow.transaction do
      @follow = @follow_request.requester.following_relationships.build(followed: current_user)
      @follow.save!
      @follow_request.destroy!
    end
    redirect_to users_path
  rescue ActiveRecord::RecordInvalid
    redirect_to users_path, alert: "Something went wrong"
  end

  def destroy
    if @follow_request.requester != current_user
      redirect_to users_path, alert: "You cannot perform this action."
      return
    end

    if @follow_request.destroy
      redirect_to users_path
    else
      redirect_to users_path, alert: "Something went wrong"
    end
  end

  private
    def set_follow_request
      @follow_request = FollowRequest.find(params[:id])
    end
end
