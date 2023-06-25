class Public::RestaurantsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  #自然言語機能のAPIを呼んで来ている。
  require 'language'
  
  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.score = Language.get_data(restaurant_params[:introduction])
      @restaurant.user_id = current_user.id
      @tag_list = params[:restaurant][:name].split(',')
      if  @restaurant.save
          @restaurant.save_tag(@tag_list)
          redirect_to restaurant_path(@restaurant.id)
      else
        render :new
      end
  end

  def index
      @q =Tag.ransack(params[:q])
      @q2 = Restaurant.ransack(params[:q])
      @tags = Tag.all
    if params[:latest]
      @restaurants = Restaurant.latest.page(params[:page]).per(6)
    elsif params[:old]
      @restaurants = Restaurant.old.page(params[:page]).per(6)
    elsif params[:star_count]
      @restaurants = Restaurant.star_count.page(params[:page]).per(6)
    else
      @q2 = Restaurant.ransack(params[:q])
      @restaurants = @q2.result(distinct: true)
      @q = Tag.ransack(params[:q])
      @tag_list = @q.result(distinct: true)
      if params[:tag_id].present?
        @tag = Tag.find(params[:tag_id])
        @restaurants = @tag.restaurants
      end
      if params[:q].present? && params[:q][:name_cont].present?
        restrant_tags = RestaurantTag.where(tag_id: @tag_list.pluck(:id))
        @restaurants = Restaurant.where(id: restrant_tags.pluck(:restaurant_id))
      end
      #レストランに紐ずくいいねを一括で取ってくる
      @restaurants = @restaurants.includes(:favorites).
      #いいねされた日付を最新のものから並び替えるソート機能。配列にし（a,b）を比較している
        sort {|a,b|
          b.favorites.select(:created_at).order(created_at: :desc).first(1) <=>
          a.favorites.select(:created_at).order(created_at: :desc).first(1)
        }
      @restaurants = Kaminari.paginate_array(@restaurants).page(params[:page]).per(6)
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @comment = Comment.new
    @restaurant_tags = @restaurant.tags
    @q = @restaurant.tags.ransack(params[:q])
    @tags = @q.result(distinct: true)
    #タグIDは存在しているか確認。存在している場合は実行する
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      #取ってきたタグに紐ずくレストラン全てをとってくる
      @restaurant = @tag.restaurants
    end
  end

  def edit
    @tag_list = @restaurant.tags.pluck(:name).join(',')
  end

  def update
    @restaurant.score = Language.get_data(restaurant_params[:introduction])
    tag_list = params[:restaurant][:name].split(',')
    #パラメータからのデータを使用して@restaurantを更新しようとする。
    if  @restaurant.update(restaurant_params)
    #更新が成功した場合は、@restaurant.save_tag(tag_list)を呼び出して、@restaurantに関連するタグ情報を保存する
        @restaurant.save_tag(tag_list)
        redirect_to restaurant_path(@restaurant.id)
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_path
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:shop_name, :introduction, :image, :star, :address)
  end
  
  def is_matching_login_user
    @restaurant = current_user.restaurants.find_by(id: params[:id])
    redirect_to root_path unless @restaurant
  end
end
