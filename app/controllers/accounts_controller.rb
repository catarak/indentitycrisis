class AccountsController < ApplicationController
  # before_filter :current_member?, :except => [:index]
  
  def show
    @account = Account.find(params[:id])
    @recent_tweets = TwitterApi.new(@account.application_token, @account.application_token_secret, @account.access_token, @account.access_token_secret).grab_10_most_recent(@account.name)
  end

  def new
    @account = Account.new
    @group = Group.find(params[:group_id])
    #run js to render new account form
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      render 'create'
    else
      render json: {error: "Your account failed to save"}, status: 400
    end
  end


  private
    def account_params
      params.require(:account).permit(:name, :application_token, :application_token_secret, :access_token, :access_token_secret, :group_id)
    end

    def current_member?
      group_id = Group.find(params[:group_id])
      # @is_member = User.joins(:memberships).where(memberships: {group_id: group_id}).find_by(memberships: {user_id:current_user.id})
      # if !@is_member
      #   redirect_to root_url, :alert => "You are not part of this account!!"
      # end
    end
end
