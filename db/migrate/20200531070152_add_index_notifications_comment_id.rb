class AddIndexNotificationsCommentId < ActiveRecord::Migration[6.0]
  def change
    add_index :notifications, :comment_id
  end
end
