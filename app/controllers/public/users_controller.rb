class Public::UsersController < ApplicationController
  
  def index
    @users = User.where(is_deleted: false)
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
    @user = current_user
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行しました"
    redirect_to root_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :profile_image, :user_introduction)
  end
end
