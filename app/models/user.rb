class User < ActiveRecord::Base

  has_many :memberships
  has_many :groups, -> { where(memberships: { state: "approved" }) }, 
            :through => :memberships
  has_many :pending_groups, -> { where(memberships: { state: "pending" }) },        through: :pending_memberships, 
            source: :group
     # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:linkedin] 
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end


  def member_of?(group)
    memberships.find_by(group_id: group.id)
  end

end
