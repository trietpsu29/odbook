class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :redirect_authenticated_user
  def home
  end

private
  def redirect_authenticated_user
    redirect_to posts_path if user_signed_in?
  end
end
