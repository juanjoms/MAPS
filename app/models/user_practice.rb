class UserPractice < ActiveRecord::Base
  ratyrate_rateable "added_value"
  belongs_to :user
  belongs_to :practice

end
