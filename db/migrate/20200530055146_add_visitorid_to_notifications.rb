class AddVisitoridToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :action, :string
    add_column :notifications, :checked, :boolean 
    add_column :notifications, :visitor_id, :integer
    add_column :notifications, :visited_id,:integer
  end
end
