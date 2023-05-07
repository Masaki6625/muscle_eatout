class Public::RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
      @restaurant.user_id = current_user.id
      tag_list = params[:restaurant][:name].split(',')
      if  @restaurant.save
          @restaurant.save_tag(tag_list)
          redirect_to restaurant_path(@restaurant.id)
      else  
        render :new
      end
  end

  def index
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result(distinct: true)
    @tag_list = Tag.all
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @restaurants = @tag.restaurants
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @comment = Comment.new
    @restaurant_tags = @restaurant.tags
    @tags = Tag.all
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @restaurant = @tag.restaurants
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    @tag_list = @restaurant.tags.pluck(:name).join(',')
  end
  
  def update
    @restaurant = Restaurant.find(params[:id])
    tag_list = params[:restaurant][:name].split(',')
    if  @restaurant.update(restaurant_params)
        @restaurant.save_tag(tag_list)
        redirect_to restaurant_path(@restaurant.id)
    else
      render :edit
    end
  end

  def destroy
    restaurant = Restaurant.find(params[:id])
    restaurant.destroy
    redirect_to restaurants_path
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:shop_name, :introduction, :image)
    end
end
