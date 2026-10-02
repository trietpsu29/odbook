class DebugController < ApplicationController
  def smtp
    settings = ActionMailer::Base.smtp_settings

    render plain: {
      address: settings[:address],
      port: settings[:port],
      username_present: settings[:user_name].present?,
      password_present: settings[:password].present?,
      delivery_method: ActionMailer::Base.delivery_method
    }.inspect
  end
end
