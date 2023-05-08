class Public::UsersController < ApplicationController
before_action :authenticate_user!
#before_action :set_user, only: [:favorites]

  def index
    @users = User.where(is_deleted: false)
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @restaurant = @user.restaurants
  end

  def edit
    is_matching_login_user
    @user = User.find(params[:id])
  end

  def update
    is_matching_login_user
    @user = User.find(params[:id])
    @user.update!(user_params)
    redirect_to user_path(current_user.id)
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
  
  # favorites
    #favorite = Favorite.where(user_id: @user.id).pluck(:restaurant_id)
    #@favorite_restaurants = Restaurant.find(favorites)
  #end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :user_introduction)
  end

  #def set_user
    #@user = User.find(params[:id])
  ##end

  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
end
