class Public::CommentsController < ApplicationController

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @comment = current_user.comments.new(comment_params)
    @comment.restaurant_id = @restaurant.id
    @restaurant.create_notification_comment!(current_user, @comment.id) #通知機能のメソッド
    @comment.save

  end

  def destroy
    Comment.find(params[:id]).destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
