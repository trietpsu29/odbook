module UsersHelper
  def user_avatar(user, class_name: "avatar")
    if user.avatar.attached?
      image_tag user.avatar, class: "#{class_name}"
    else
      image_tag "default-avatar.svg", class: "#{class_name}"
    end
  end
end
