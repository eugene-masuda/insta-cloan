class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]
  
  def index
      @notifications = current_user.passive_notifications
      @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
      end
  end
  
  
end