class WelcomeController < ApplicationController
  before_action :authenticate_user!, only: [:secret]

  def index
    if user_signed_in?
      redirect_to questions_path
    end

  end
end
