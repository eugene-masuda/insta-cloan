module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    your_micropost = link_to "あなたの投稿", micropost_path(notification.micropost_id), style:"font-weight: bold;"
    @visiter_comment = notification.comment_id

    case notification.action
      when "like" then
        tag.a(notification.visiter.user_name, href:user_path(@visiter), style:"font-weight: bold;") + "が" + your_micropost + "にいいねしました"
    end
  end
  
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end