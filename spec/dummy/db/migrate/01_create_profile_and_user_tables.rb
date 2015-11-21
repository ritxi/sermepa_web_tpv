class CreateProfileAndUserTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.timestamps
    end

    create_table :profiles do |t|
      t.integer :user_id
      t.boolean :default
      t.timestamps
    end
  end
end