class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.timestamps
    end
    add_index :notifications, :user_id
  end
end
