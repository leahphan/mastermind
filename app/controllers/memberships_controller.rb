class MembershipsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete, :destroy]

  def create 
    @membership = Membership.create!(membership_params)

    if @membership.save
  	flash[:success] = "Your request to join the group has been received. You will receive an email once the Group Owner has approved your request."
    redirect_to groups_url
    end
  end

  def destroy
  	@membership = Membership.where(:user_id => params[:membership][:user_id], :group_id => params[:membership][:group_id]).first
    if @membership.destroy!
    flash[:success] = "You have left this Mastermind group."
    redirect_to groups_url
    end
  end

  private
    def membership_params
      params.require(:membership).permit(:group_id, :user_id)
    end
end