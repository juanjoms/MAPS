class UserPracticeController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_complete!
  before_action :association_complete!

  def index
    user_practices = UserPractice.where(user_id: current_user.id)
    user_practices.each do |up|
      if up.answer.nil?
        @current_user_practice = up
        break
      end
    end
  end

  # PATCH /user_practice/:id
  def update
    @current_user_practice = UserPractice.find(params[:id])
    respond_to do |format|
      if @current_user_practice.update(user_practice_params)
        format.html { redirect_to user_practice_index_path }
        format.js
      else
        raise "Nope, no se creó"
      end
    end
  end

  def done

    @company = Company.find(current_user.company_id)
    @cont_users = User.where(company_id:@company.id).count
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
    params.require(:user_practice).permit(:answer)
  end


end
