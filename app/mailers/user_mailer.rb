class UserMailer < ApplicationMailer
  default from: "odbook.app@gmail.com"

  def welcome_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Welcome to Odin Book"
    )
  end
end
