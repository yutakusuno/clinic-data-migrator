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

      unless patient
        error_message = "Row #{index + 1}: Patient with health identifier #{row['health identifier']} not found."
        migration_errors << error_message
        next
      end

      existing_vital = Vital.find_by(
        patient: patient,
        vital_type: row["vital_type"],
        measurement: row["measurement"].to_f,
        units: row["units"]
      )

      if existing_vital
        error_message = "Row #{index + 1}: Vital #{row['vital_type']} for patient #{patient.id} already exists."
        migration_errors << error_message
        next
      end

      vital = Vital.new(
        patient: patient,
        vital_type: row["vital_type"],
        measurement: row["measurement"].to_f,
        units: row["units"]
      )

      unless vital.save
        error_message = "Row #{index + 1}: Vital #{row['vital_type']} creation failed: #{vital.errors.full_messages.join(', ')}"
        migration_errors << error_message
        next
      end

      imported_count += 1
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
