class OwnerNotifier < ActionMailer::Base
  default from: "from@example.com"

  def group_join_requested(membership_id)
  	membership = Membership.find(membership_id)

  	@member = membership.user 
  	@group = membership.group  
  	@owner = @group.users.where("memberships.role = 'owner'").first

  	mail to: @owner.email,
  				subject: "#{@member.name} would like to become a member of #{@group.name}."
  end

  def group_join_approved(membership_id)
  	membership = Membership.find(membership_id)

  	@member = membership.user 
  	@group = membership.group  
  	@owner = @group.users.where("memberships.role = 'owner'").first

  	mail to: @owner.email,
  				subject: "#{@owner.name} has approved your request to join #{@group.name}."
  end

end
