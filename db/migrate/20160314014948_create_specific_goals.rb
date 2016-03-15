class CreateSpecificGoals < ActiveRecord::Migration
  def change
    create_table :specific_goals do |t|
      t.string :name
      t.string :description

      t.references :process_areas
      t.timestamps null: false
    end
  end
end
