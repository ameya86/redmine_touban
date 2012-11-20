class CreateToubanUsers < ActiveRecord::Migration
  def change
    create_table :touban_users do |t|
      t.integer :touban_id
      t.integer :user_id
      t.integer :position
    end
    add_index :touban_users, [:touban_id, :user_id], :unique => true
  end
end
