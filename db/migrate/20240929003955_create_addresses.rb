class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :patient, foreign_key: true, null: false
      t.string :address_1
      t.string :address_2
      t.string :province
      t.string :city
      t.string :postal_code

      t.timestamps
    end
  end
end
