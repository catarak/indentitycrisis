class GroupsController < ApplicationController
  before_action :current_member?, :except => [:index, :new, :create]

  def index
    @groups = current_user.groups
  end

  def show
    #add a before filter to check if user is privileged to see group
    @group = Group.find(params[:id])
    @members = User.joins(:memberships).where(memberships: {group_id: params[:id]})
    @accounts = Account.where(group_id: params[:id])
    @user = User.new
  end

  def new
    @group = Group.new
    #@group.accounts.build
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      Membership.create(group_id: @group.id, user_id: current_user.id, role: :admin)
      redirect_to group_path(@group)
    end
  end

  private
    def group_params
      params.require(:group).permit(:name, accounts_attributes: [:name, :access_token, :access_token_secret, :application_token, :application_token_secret])
    end

    def current_member?
      @is_member = User.joins(:memberships).where(memberships: {group_id: params[:id]}).find_by(memberships: {user_id:current_user.id})
      if !@is_member
        redirect_to root_url, :alert => "You are not part of this group!!"
      end
    end
end
