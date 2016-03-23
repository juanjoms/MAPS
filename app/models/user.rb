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

  def is_developer?
    self.position >= 1
  end

  def is_sepg?
    self.position >= 2
  end

  def is_admin?
    self.position >= 3
  end

end
