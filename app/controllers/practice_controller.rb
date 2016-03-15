class PracticeController < ApplicationController
  before_action :authenticate_user!, only: [:questions, :complete_profile]
  before_action :profile_complete!, only: [:questions]

  # GET /questions/
  def questions
    @practices = Practice.paginate(:page => params[:page], :per_page => 5)
  end

end
