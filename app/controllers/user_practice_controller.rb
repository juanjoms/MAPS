class UserPracticeController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_complete!
  before_action :association_complete!, only: [:index]

  def index
    @finished = false
    user_practices = UserPractice.where(user_id: current_user.id)
    user_practices.each do |up|
      if up.answer.nil?
        @current_user_practice = up
        break
      end
    end
    if @current_user_practice.nil?
      @finished = true
    else
      @practice = @current_user_practice.practice
    end
  end

  # PATCH /user_practice/:id
  def update
    @current_user_practice = UserPractice.find(params[:id])
    if @current_user_practice.update(user_practice_params)
      redirect_to user_practice_index_path
    else
      raise "Nope, no se creó"
    end
  end



  private
  def association_complete!
    user_practices = UserPractice.where("user_id": current_user.id)

    if user_practices.count == 0
      practices = Practice.all
      practices.each do |practice|
        UserPractice.create(user_id: current_user.id, practice_id: practice.id)
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_practice_params
    params.require(:user_practice).permit(:answer, :added_value)
  end


end
