class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

<<<<<<< HEAD
  def profile_complete!
    redirect_to edit_user_registration_path,
      alert: "Necesita completar los campos: Organización y puesto en su perfil antes de comenzar" unless current_user.has_profile_complete?
  end


=======
>>>>>>> 42f2c83f52beda2485d6231bdd0f90c7395645c6
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def configure_permitted_parameters
<<<<<<< HEAD
    devise_parameter_sanitizer.for(:sign_up).push(:name, :company_id, :position)

    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) << :company_id
    devise_parameter_sanitizer.for(:account_update) << :position

=======
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
>>>>>>> 42f2c83f52beda2485d6231bdd0f90c7395645c6
  end
end
