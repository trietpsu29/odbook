class FollowRequestsController < ApplicationController
  before_action :set_follow_request, only: [ :destroy, :accept ]

  def create
    @user = User.find(params[:user_id])

    if @user == current_user
      render_follow_button_error(
        @user,
        "You cannot follow yourself."
      )
      return
    end

    @follow_request = current_user.sent_follow_requests.build(requested: @user)

    if @follow_request.save
      render_follow_button_update(@user)
    else
      render_follow_button_error(
        @user,
        @follow_request.errors.full_messages.join("\n")
      )
    end
  end

  def accept
    if @follow_request.requested != current_user
      render_follow_button_error(
        @follow_request.requested,
        "You are not allowed to accept this request."
      )
      return
    end

    Follow.transaction do
      @follow = @follow_request.requester.following_relationships.build(
        followed: current_user
      )

      @follow.save!
      @follow_request.destroy!
    end

    render_follow_button_update(@follow_request.requester)

  rescue ActiveRecord::RecordInvalid
    render_follow_button_error(
      @follow_request.requester,
      @follow_request.errors.full_messages.join("\n")
    )
  end

  def destroy
    if @follow_request.requester == current_user
      user = @follow_request.requested
    elsif @follow_request.requested == current_user
      user = @follow_request.requester
    else
      render_follow_button_error(
        @follow_request.requested,
        "You are not authorized to do that."
      )
      return
    end

    if @follow_request.destroy
      render_follow_button_update(user)
    else
      render_follow_button_error(
        user,
        @follow_request.errors.full_messages.join("\n")
      )
    end
  end

  private

    def set_follow_request
      @follow_request = FollowRequest.find(params[:id])
    end

    def render_follow_button_update(user)
      respond_to do |format|
        format.turbo_stream do
          render "shared/update_follow_button",
            locals: { user: user }
        end

        format.html do
          redirect_to users_path
        end
      end
    end

    def render_follow_button_error(user, message)
      respond_to do |format|
        flash.now[:alert] = message

        format.turbo_stream do
          render "shared/update_follow_button",
            locals: { user: user },
            status: :unprocessable_entity
        end

        format.html do
          redirect_to users_path,
            alert: message,
            status: :unprocessable_entity
        end
      end
    end
end
