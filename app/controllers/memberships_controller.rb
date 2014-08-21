class MembershipsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete, :destroy]

  # Before filter for CanCan 
  load_and_authorize_resource

  def review
    @membership = Membership.find(params[:id])
    @user = @membership.user 
  end

  def approve 
    @membership = Membership.find(params[:id])
    if @membership.approve!
      flash[:success] = "Request approved."
    else 
      flash[:error] = "That request could not be approved."
    end
    redirect_to(:back)
  end

  def reject 
    @membership = Membership.find(params[:id])
    if @membership.reject!
      flash[:success] = "Member rejected from group."
    else 
      flash[:error] = "That request could not be rejected."
    end
    redirect_to(:back)
  end

  def create 
    @membership = Membership.request(params[:membership][:group_id], params[:membership][:user_id])

    if @membership.new_record?
      flash[:error] = "There was a problem creating your request to join a group."
    else
  	 flash[:success] = "Your request to join the group has been sent. You will receive an email once the Group Owner has approved your request."
    end
    redirect_to(:back)
  end

  def edit 
    @membership = current_user.memberships.find(params[:id])
    @user = @membership.user 
  end

  def destroy
  	@membership = Membership.where(:user_id => params[:membership][:user_id], :group_id => params[:membership][:group_id]).first
    if @membership.destroy!
    flash[:success] = "You have left this Mastermind group."
    end
    redirect_to(:back)
  end

  private
    def membership_params
      params.require(:membership).permit(:group_id, :user_id, :role, :state)
    end
end