class Group < ActiveRecord::Base

	has_many :memberships
  has_many :users, :through => :memberships
  after_save :make_owner

  def make_owner
    # Make membership to own group setting user as owner
    self.memberships.create(:role => "owner", :user_id => self.user_id)
  end

  def owners
  	User.find(self.memberships.where(role: 'owner').map(&:user_id))
	end

end
