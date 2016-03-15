class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.string :name
      t.string :question
      t.text :examples
      t.integer :added_value

      t.references :specific_goals
      t.timestamps null: false
    end
  end
end
