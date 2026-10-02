class DebugController < ApplicationController
  def smtp
    base = ActionMailer::Base
    devise = Devise::Mailer

    render plain: {
      base_address: base.smtp_settings[:address],
      base_port: base.smtp_settings[:port],
      base_delivery_method: base.delivery_method,

      devise_address: devise.smtp_settings[:address],
      devise_port: devise.smtp_settings[:port],
      devise_delivery_method: devise.delivery_method
    }.inspect
  end
end
