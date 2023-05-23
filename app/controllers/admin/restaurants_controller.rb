class Admin::RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def destroy
   restaurant = Restaurant.find(params[:id])
   restaurant.destroy
   redirect_to admin_restaurants_path
  end
end
