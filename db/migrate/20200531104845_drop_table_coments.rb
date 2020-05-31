class DropTableComents < ActiveRecord::Migration[6.0]
  def change
    drop_table :coments
  end
end
