class Public::UsersController < ApplicationController
  #ユーザーがログイン済みであるかどうかを確認している
  before_action :authenticate_user!

  def index
    #whereメソッドを使用してクエリを構築、条件としてis_deleted属性がfalse（退会していない）であるユーザーを選択する
    @users = User.where(is_deleted: false).page(params[:page])
    @user = current_user
  end

  def show
    @user = current_user
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
    if @user.update(user_params)
      redirect_to user_path(current_user.id)
    else
      render :edit
    end
  end

  def unsubscribe
    @user = current_user
    @user.update(is_deleted: true)
    @user.destroy_unsubscribe_user_info
    reset_session
    flash[:notice] = "退会処理を実行しました"
    redirect_to root_path
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:restaurant_id)
    @favorite_restaurants = Restaurant.find(favorites)
  end


  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :user_introduction)
  end

  #このメソッドがついているところは自身のユーザーIDじゃなかったら現在のユーザーのページへ
  #リダイレクトするようにしている
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id #ユーザーIDと現在のユーザーが一致しているか？（一致していたら）trueを返す
      redirect_to user_path(current_user.id)
    end
  end
end
