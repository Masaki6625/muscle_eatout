class Admin::CommentsController < ApplicationController

  def destroy
    comment = Comment.find(params[:id])
    @restaurant = comment.restaurant
    comment.destroy
  end
end
