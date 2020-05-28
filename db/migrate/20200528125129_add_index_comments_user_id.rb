class AddIndexCommentsUserId < ActiveRecord::Migration[6.0]
  def change
    add_index :comments, :user_id 
    add_index :comments, :micropost_id 
  end
end
