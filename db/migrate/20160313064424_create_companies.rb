class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.text :as_is_diagram
      t.text :final_diagram
      t.integer :employees_number
      #1) NO, 2) < 1 año, 3) < 3años, 4) > 3 años
      t.integer :process_experience
      #1) Ninguna, 2) De 1-3, 3) < 3-5, 4) > 5
      t.integer :spi_experience

      t.timestamps null: false

      #Para saber a que elemento agregar
      t.string :final_element, default: 'StartEvent_0gwlf1v'
    end
  end
end
