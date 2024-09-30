class CreateHealthIdentifiers < ActiveRecord::Migration[7.2]
  def change
    create_table :health_identifiers do |t|
      t.references :patient, foreign_key: true, null: false
      t.string :identifier_number, null: false
      t.string :province_of_origin, null: false

      t.timestamps
    end

    add_index :health_identifiers, [:identifier_number, :province_of_origin], unique: true
  end
end
