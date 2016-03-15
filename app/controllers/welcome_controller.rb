class WelcomeController < ApplicationController
  before_action :authenticate_user!, only: [:secret]
  
  def index

  end

  def secret
    @text = "Este texto lo estoy declarando en el controlador"
  end
end
