class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  #before_action :if_not_admin
  #before_action :set_restaurant, only: [:index, :show ,:destroy]
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @restaurant = @user.restaurants
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path
  end

  def unsubscribe
    @user = User.find(params[:id])
    @user.update(is_deleted: !@user.is_deleted)
    @user.destroy_unsubscribe_user_info
    flash[:notice] = "退会処理を実行しました"
    redirect_to admin_users_path
  end

  
end
