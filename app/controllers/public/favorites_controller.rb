class Public::FavoritesController < ApplicationController

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    favorite = current_user.favorites.new(restaurant_id: @restaurant.id)
    favorite.save
    #redirect_to restaurant_path(restaurant)
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    favorite = current_user.favorites.find_by(restaurant_id: @restaurant.id)
    favorite.destroy
    #redirect_to restaurant_path(restaurant)
  end

end
