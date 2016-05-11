class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.text :as_is_diagram
      t.text :final_diagram      
      t.timestamps null: false
    end
  end
end
