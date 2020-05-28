class CreateComents < ActiveRecord::Migration[6.0]
  def change
    create_table :coments do |t|
      t.integer :user_id
      t.integer :micropost_id
      t.text :content

      t.timestamps
    end
     add_index :coments, :user_id
    add_index :coments, :micropost_id
  end
end
