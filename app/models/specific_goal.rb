class SpecificGoal < ActiveRecord::Base
  belongs_to :process_area
  has_many :practices
end
