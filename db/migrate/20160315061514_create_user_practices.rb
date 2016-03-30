class CreateUserPractices < ActiveRecord::Migration
  def change
    create_table :user_practices do |t|
      t.belongs_to :user, index: true
      t.belongs_to :practice, index: true

      t.integer :answer
      #a) Siempre b) Regularmente c) Pocas veces d) Nunca e) No sabe => [1,2,3,4,5]

      t.float :added_value, default: 0.0
      #1-5 estrellas  => [0.0-5.0]

      t.timestamps null: false
    end
  end
end
