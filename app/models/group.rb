class Group < ActiveRecord::Base

	has_many :memberships, dependent: :destroy
  has_many :users, -> { where(memberships: { state: "approved" }) },
            :through => :memberships
  has_many :pending_members, -> { where(memberships: { state: "pending" }) },        through: :pending_memberships, 
            source: :user 

  after_save :make_owner

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  def make_owner
    # Make membership to own group setting user as owner
    self.memberships.create(:role => "owner", :user_id => self.user_id, :state => "approved")
  end

  def owners
  	User.find(self.memberships.where(role: 'owner').map(&:user_id))
	end

  def tag_tokens=(ids)
    ids = ids.split(',')
    self.tag_list = Tag.where(:id => ids).map(&:name)
  end
end
