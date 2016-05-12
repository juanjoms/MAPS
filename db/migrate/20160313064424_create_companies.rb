class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.text :as_is_diagram
      t.text :final_diagram
      t.integer :employees_number
      t.timestamps null: false

      #Para saber a que elemento agregar
      t.string :final_element, default: 'StartEvent_0gwlf1v'
    end
  end
end
