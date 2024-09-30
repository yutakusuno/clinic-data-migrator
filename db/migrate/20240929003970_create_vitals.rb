class CreateVitals < ActiveRecord::Migration[7.2]
  def change
    create_table :vitals do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :vital_type, null: false
      t.decimal :measurement, precision: 10, scale: 2, null: false
      t.string :units, null: false

      t.timestamps
    end
  end
end
