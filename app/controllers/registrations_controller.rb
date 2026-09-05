class RegistrationsController < Devise::RegistrationsController
  def after_update_path_for(resource)
    flash[:notice] = "Account updated successfully!"
    edit_user_path(resource)
  end
end
