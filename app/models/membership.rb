class Membership < ActiveRecord::Base

	belongs_to :user
	belongs_to :group

	state_machine :state, :initial => :pending do 
		after_transition on: :approve, do: :send_approval_email
		event :approve do 
			transition any => :approved
		end
		event :reject do 
			transition any => :rejected
		end
	end

	def self.request(group_id, user_id)
		transaction do 
			membership = create(group_id: group_id, user_id: user_id, 
				role: 'member', state: 'pending')

			membership.send_request_email
			membership
		end
	end

	def send_request_email 
		OwnerNotifier.group_join_requested(id).deliver
	end

	def send_approval_email 
		OwnerNotifier.group_join_approved(id).deliver
	end

  def owner_of_group
  	User.find(self.memberships.where(role: 'owner').map(&:user_id))
	end

end
