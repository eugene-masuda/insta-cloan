class AddIndexToNotificationsMicropostId < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :micropost_id, :integer
  end
end
