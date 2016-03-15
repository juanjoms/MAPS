class User < ActiveRecord::Base
  belongs_to :company
<<<<<<< HEAD
  has_many :user_practices
  has_many :practices, through: :user_practices

=======
>>>>>>> 42f2c83f52beda2485d6231bdd0f90c7395645c6
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
<<<<<<< HEAD



  def has_profile_complete?
    (self.position != nil) and (self.company_id != nil)
  end

=======
>>>>>>> 42f2c83f52beda2485d6231bdd0f90c7395645c6
end
