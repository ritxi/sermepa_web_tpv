class CreateTabsTable < ActiveRecord::Migration
  def change
    create_table :tabs do |t|
      t.boolean :default
      t.timestamps
    end
  end
end