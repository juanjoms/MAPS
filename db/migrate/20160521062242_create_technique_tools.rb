class CreateTechniqueTools < ActiveRecord::Migration
  def change
    create_table :technique_tools do |t|
      t.string :name

      #0 Sencilla, 1 Media, 2 Complicada
      t.integer :complexity
      #0 matemático, 1 personas, 2 grafico
      t.integer :approach

      t.references :practice
      t.timestamps null: false
    end
  end
end
