class AddContentstoComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :micropost_id, :integer
    add_column :comments, :user_id, :integer
    add_column :comments, :content, :text
  end
end
