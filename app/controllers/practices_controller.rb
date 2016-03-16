class PracticesController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_complete!

  #GET /questions/
  def index
    @practices = Practice.paginate(:page => params[:page], :per_page => 1)
    @text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  end

  def index
    @practices = Practice.paginate(:page => params[:page], :per_page => 1)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @practices }
      format.js
    end
  end
end
