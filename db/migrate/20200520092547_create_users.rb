class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :user_name
      t.text :website
      t.text :introduction
      t.text :phone_number
      t.string :sex

      t.timestamps
    end
  end
end
