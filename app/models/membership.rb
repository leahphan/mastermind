class Membership < ActiveRecord::Base

	belongs_to :user
	belongs_to :group

	state_machine :state, :initial => :pending do 
		after_transition on: :approve, do: :send_approval_email
		event :approve do 
			transition any => :approved
		end
	end

	def self.request(member, group)
		transaction do 
			membership = create(user_id: member, group_id: group, state: 'pending')

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

end
