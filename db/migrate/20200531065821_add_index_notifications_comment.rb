class AddIndexNotificationsComment < ActiveRecord::Migration[6.0]
  def change
     add_index :notifications, :comment
  end
end
