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
    @q2 = Restaurant.ransack(params[:q])
    @restaurants = @q2.result(distinct: true).page(params[:page]).per(6)
    @q = Tag.ransack(params[:q])
    @tag_list = @q.result(distinct: true)
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @restaurants = @tag.restaurants.page(params[:page]).per(6)
    end

    if params[:q].present? && params[:q][:name_cont].present?
      restrant_tags = RestaurantTag.where(tag_id: @tag_list.pluck(:id))
      @restaurants = Restaurant.where(id: restrant_tags.pluck(:restaurant_id))
      # pp @tag_list,restrant_tags, @restaurants
       @restaurant = Restaurant.includes(:favorited_users).
      sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @comment = Comment.new
    @restaurant_tags = @restaurant.tags
    @q = @restaurant.tags.ransack(params[:q])
    @tags = @q.result(distinct: true)
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
      params.require(:restaurant).permit(:shop_name, :introduction, :image, :star, :address)
    end
end
