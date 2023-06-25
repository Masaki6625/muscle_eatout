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
    reset_session
    flash[:notice] = "退会処理を実行しました"
    redirect_to admin_users_path
  end

  #private

  #def if_not_admin
    #redirect_to root_path unless current_user.admin?
  #end

  #d#ef admin?
    #if current_user == admin
    #end
  #end
  #def set_restaurant
    #@restaurant = Restaurant.find(params[:id])
  #end
end
