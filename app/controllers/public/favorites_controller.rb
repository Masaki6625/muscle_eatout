class Public::FavoritesController < ApplicationController
  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    favorite = current_user.favorites.new(restaurant_id: @restaurant.id)
    favorite.save
    create_notification_like(@restaurant) # 通知機能のメソッドを呼び出す

    respond_to do |format|
      format.html { redirect_to restaurant_path(@restaurant) }
      format.js # create.js.erbをレンダリングする
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    favorite = current_user.favorites.find_by(restaurant_id: @restaurant.id)
    favorite.destroy

    respond_to do |format|
      format.html { redirect_to restaurant_path(@restaurant) }
      format.js # destroy.js.erbをレンダリングする
    end
  end

  private

  def create_notification_like(restaurant)
    return if restaurant.user == current_user
  
    notification = current_user.active_notifications.new(
      visited_id: restaurant.user.id,
      action: 'like'
    )
    notification.save
  end

end
