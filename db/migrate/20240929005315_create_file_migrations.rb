class CreateFileMigrations < ActiveRecord::Migration[7.2]
  def change
    create_table :file_migrations do |t|
      t.string :file_name, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.integer :imported_count, default: 0
      t.text :migration_errors

      t.timestamps
    end
  end
end
