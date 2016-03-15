class Practice < ActiveRecord::Base
  belongs_to :specific_goals
  has_many :user_practices
  has_many :users, through: :user_practices
end
