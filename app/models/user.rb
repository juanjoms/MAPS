class User < ActiveRecord::Base
  belongs_to :company
  has_many :user_practices
  has_many :practices, through: :user_practices

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def has_profile_complete?
    (self.position != nil) and (self.company_id != nil)
  end

end
