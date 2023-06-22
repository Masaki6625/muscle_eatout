class Public::FavoritesController < ApplicationController

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.create_notification_like!(current_user) #通知機能のメソッド
    favorite = current_user.favorites.new(restaurant_id: @restaurant.id)
    favorite.save
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    favorite = current_user.favorites.find_by(restaurant_id: @restaurant.id)
    favorite.destroy
  end

end
