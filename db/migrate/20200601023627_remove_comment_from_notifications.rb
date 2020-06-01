class RemoveCommentFromNotifications < ActiveRecord::Migration[6.0]
  def change
    remove_index :notifications, :comment
    remove_column :notifications, :comment, :string
  end
end
