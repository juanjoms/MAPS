class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true
  after_save :update_user_practice

  #attr_accessible :rate, :dimension
  def update_user_practice
    UserPractice.find(self.rateable_id).update(added_value: self.stars)
  end

end
