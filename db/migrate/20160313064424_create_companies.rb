class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
<<<<<<< HEAD
      t.text :description
=======
      t.string :description
>>>>>>> 42f2c83f52beda2485d6231bdd0f90c7395645c6

      t.timestamps null: false
    end
  end
end
