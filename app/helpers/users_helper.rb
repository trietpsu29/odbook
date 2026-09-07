module UsersHelper
  def user_avatar(user, class_name: "avatar", data: {})
    if user.avatar.attached? && user.avatar.blob.persisted?
      image_tag user.avatar,
        class: class_name,
        data: data
    else
      image_tag "default-avatar.svg",
        class: class_name,
        data: data
    end
  end

  def follow_button(user, filter = nil)
    if user == current_user
      content_tag :div, class: "edit-profile-container" do
        link_to "Edit profile",
          edit_user_path(current_user),
          class: "follow-button edit"
      end

    elsif filter == "requests"
      request = current_user.received_follow_requests.find_by(requester: user)

      render "shared/follow_request_buttons", request: request

    elsif filter == "following"
      follow = current_user.following_relationships.find_by(followed: user)

      button_to "Unfolclow",
        follow_path(follow),
        method: :delete,
        class: "follow-button unfollow"

    elsif filter == "followers"
      follow = current_user.follower_relationships.find_by(follower: user)

      button_to "Remove follower",
        follow_path(follow),
        method: :delete,
        class: "follow-button remove-follower",
        data: { turbo_confirm: "Are you sure you want to remove this user?" }

    elsif filter == "requested"
      request = current_user.sent_follow_requests.find_by(requested: user)

      button_to "Cancel request",
        follow_request_path(request),
        method: :delete,
        class: "follow-button unrequested"

    else
      if current_user.following_relationships.exists?(followed: user)
        follow = current_user.following_relationships.find_by(followed: user)

        button_to "Unfollow",
          follow_path(follow),
          method: :delete,
          class: "follow-button unfollow"

      elsif current_user.sent_follow_requests.exists?(requested: user)
        request = current_user.sent_follow_requests.find_by(requested: user)

        button_to "Cancel request",
          follow_request_path(request),
          method: :delete,
          class: "follow-button unrequested"
      else
        button_to "Follow",
          user_follow_requests_path(user),
          method: :post,
          class: "follow-button"
      end
    end
  end
end
