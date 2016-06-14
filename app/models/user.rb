class User < ActiveRecord::Base
  belongs_to :company
  has_many :user_practices
  has_many :practices, through: :user_practices
  ratyrate_rater
  include Gravtastic
  gravtastic

  validate :check_postion_sepg



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def check_postion_sepg
    if self.position == 2
      sepgs = self.company.users.where(position:2)
      errors.add(:position, "- Ya está registrado el siguiente encargado de mejoras: #{sepgs.first.name} ") if sepgs.exists?
    end
  end

  def has_profile_complete?
    (self.position != nil) and (self.company_id != nil)
  end

  def is_process_user?
    self.position == 1
  end

  def is_sepg?
    self.position == 2
  end

  def is_admin?
    self.position == 3
  end

end
