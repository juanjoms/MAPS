class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.string :name
      t.string :question
      t.text :examples

      #0 No necessary, 1 necessary
      t.integer :necessary, default: 0

      t.references :specific_goals
      t.timestamps null: false
    end
  end
end
