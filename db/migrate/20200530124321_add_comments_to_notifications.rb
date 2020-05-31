class AddCommentsToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :comment_id, :integer
  end
end
