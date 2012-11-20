class CreateToubans < ActiveRecord::Migration
  def change
    create_table :toubans do |t|
      t.integer :project_id
      t.string  :name,         :default => "", :null => false
      t.text    :description,  :default => ""
      t.text    :tasks
      t.integer :touban_index, :default => 0,  :null => false
      t.integer :step,         :default => 1,  :null => false
    end

    add_index :toubans, :project_id
  end
end
