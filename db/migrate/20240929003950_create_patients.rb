class CreatePatients < ActiveRecord::Migration[7.2]
  def change
    create_table :patients do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.string :phone_number, null: false
      t.string :email
      t.date :date_of_birth, null: false
      t.string :sex, null: false
      
      t.timestamps
    end
  end
end
