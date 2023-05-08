class Admin::UsersController < ApplicationController
  def index
    @users = User.where(is_deleted: false)
  end

  def show
    @user = User.find(params[:id])
    @restaurant = @user.restaurants
  end
end
