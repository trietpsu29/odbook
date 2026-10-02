class UserMailer < ApplicationMailer
  default from: "odbook@odbook.dpdns.org"

  def welcome_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Welcome to OdBook"
    )
  end
end
