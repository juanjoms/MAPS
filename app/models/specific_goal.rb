class SpecificGoal < ActiveRecord::Base
  belongs_to :process_areas
  has_many :practices
end
