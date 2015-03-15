class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order('read asc').page(params[:page])
  end
end
