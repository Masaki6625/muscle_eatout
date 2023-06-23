class Public::NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.where.not(visited_id: deleted_user_ids).page(params[:page]).per(20)
    #通知の既読を変更している
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy_all
    @notification = Notification.where(visited_id: current_user.id)
    @notification.destroy_all
    redirect_to notifications_path
  end
end

private

def deleted_user_ids
  User.where(is_deleted: true).pluck(:id)
end