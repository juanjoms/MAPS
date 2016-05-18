class CreateScrumPractices < ActiveRecord::Migration
  def change
    create_table :scrum_practices do |t|
      t.string :name
      t.text :description
      #Guias para su implementación
      t.string :meeting
      t.text :ingredients
      t.text :procedure
      t.text :tools
      t.text :techniques
      t.string :duration

      #0-No soportada, 1-Parcialmente soportada, 2-Soportada
      t.integer :supported

      t.references :practice
      t.timestamps null: false
    end
  end
end
