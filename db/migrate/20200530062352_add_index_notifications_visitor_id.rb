class AddIndexNotificationsVisitorId < ActiveRecord::Migration[6.0]
  def change
    add_index :notifications, :visitor_id
    add_index :notifications, :visited_id
    add_index :notifications, :micropost_id
  end
end
