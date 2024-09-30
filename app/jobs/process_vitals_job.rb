require 'csv'

class ProcessVitalsJob < ApplicationJob
  queue_as :default

  def perform(file)
    file_migration = FileMigration.create!(
      file_name: file.original_filename,
      start_time: Time.current,
    )

    imported_count = 0
    migration_errors = []

    CSV.foreach(file.path, headers: true).with_index do |row, index|
      patient = HealthIdentifier.find_by(identifier_number: row["health identifier"])&.patient

      if patient
        vital = Vital.new(
          patient: patient,
          vital_type: row["vital_type"],
          measurement: row["measurement"].to_f,
          units: row["units"]
        )

        if vital.save
          imported_count += 1
        else
          error_message = "Row #{index + 1}: Vital #{row['vital_type']} creation failed: #{vital.errors.full_messages.join(', ')}"
          migration_errors << error_message
        end
      else
        error_message = "Row #{index + 1}: Patient with health identifier #{row['health identifier']} not found."
        migration_errors << error_message
      end
    end

    # File Migration Log Update
    file_migration.update!(
      end_time: Time.current,
      imported_count: imported_count,
      migration_errors: migration_errors.join("\n")
    )

    # Logging Errors
    migration_errors.each { |error| Rails.logger.error(error) }
    Rails.logger.info("Data migration completed: #{imported_count} vitals imported.")
  end
end
