class ChangeDatatypeActionOfNotifications < ActiveRecord::Migration[6.0]
  def change
     change_column :notifications, :action, :string, default: '', null:false
     change_column :notifications, :visitor_id, :integer, null:false
     change_column :notifications, :visited_id, :integer, null:false
     change_column :notifications, :checked, :boolean, default: false, null:false
  end
end
