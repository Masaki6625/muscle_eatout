class Public::UsersController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @restaurant = @user.restaurants
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to edit_user_path(current_user.id)
  end

  def withdraw
  end

  def unsubscribe
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :profile_image, :user_introduction)
  end
end
