module UsersHelper
  def user_avatar(user, size: 40)
    if user.avatar.attached?
      image_tag user.avatar, class: "avatar", size: "#{size}x#{size}"
    elsif user.avatar_url.present?
      image_tag user.avatar_url, class: "avatar", size: "#{size}x#{size}"
    else
      image_tag "default-avatar.svg", class: "avatar", size: "#{size}x#{size}"
    end
  end
end
