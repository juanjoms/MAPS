class Practice < ActiveRecord::Base
  belongs_to :specific_goal
  has_many :user_practices
  has_many :users, through: :user_practices
  has_one :scrum_practice
  has_one :technique_tool

  def progress
    return self.id / 14.0 * 100
  end

end
