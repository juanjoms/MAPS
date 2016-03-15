class CreateUserPractices < ActiveRecord::Migration
  def change
    create_table :user_practices do |t|
      t.belongs_to :user, index: true
      t.belongs_to :practice, index: true

      t.integer :respuesta
      t.integer :added_value
      #a) Siempre b) Regularmente c) Pocas veces d) Nunca e) No sabe => [1,2,3,4,5]

      t.timestamps null: false
    end
  end
end
