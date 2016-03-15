class CreateProcessAreas < ActiveRecord::Migration
  def change
    create_table :process_areas do |t|
      t.string :name
      t.string :description
      t.string :purpose

      t.timestamps null: false
    end
  end
end
