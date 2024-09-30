require 'csv'

class ProcessPatientsJob < ApplicationJob
  queue_as :default

  def perform(file)
    file_migration = FileMigration.create!(
      file_name: file.original_filename,
      start_time: Time.current,
    )

    patient_count = 0
    migration_errors = []

    CSV.foreach(file.path, headers: true).with_index do |row, index|
      ActiveRecord::Base.transaction do
        date_of_birth = row['date of birth']
        parsed_date_of_birth = begin
                                  Date.parse(date_of_birth) if date_of_birth.present?
                                rescue ArgumentError
                                  nil
                                end

        if parsed_date_of_birth.nil?
          error_message = "Row #{index + 1}: Invalid date of birth: #{date_of_birth}"
          migration_errors << error_message
          raise ActiveRecord::Rollback
        end

        patient = Patient.new(
          first_name: row['first name'],
          last_name: row['last name'],
          middle_name: row['middle name'],
          phone_number: row['phone'],
          email: row['email'],
          date_of_birth: parsed_date_of_birth,
          sex: row['sex'],
        )

        unless patient.save
          error_message = "Row #{index + 1}: Patient creation failed: #{patient.errors.full_messages.join(", ")}"
          migration_errors << error_message
          raise ActiveRecord::Rollback
        end

        address = Address.new(
          address_1: row['address 1'],
          address_2: row['address 2'],
          province: row['address province'],
          city: row['address city'],
          postal_code: row['address postal code'],
          patient: patient
        )

        unless address.save
          error_message = "Row #{index + 1}: Address creation failed: #{address.errors.full_messages.join(", ")}"
          migration_errors << error_message
          raise ActiveRecord::Rollback
        end

        health_identifier = HealthIdentifier.new(
          identifier_number: row['health identifier'],
          province_of_origin: row['health identifier province'],
          patient: patient
        )

        unless health_identifier.save
          error_message = "Row #{index + 1}: Health identifier creation failed: #{health_identifier.errors.full_messages.join(", ")}"
          migration_errors << error_message
          raise ActiveRecord::Rollback
        end

        patient_count += 1
      end
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.error("Migration failed due to unique constraint: #{e.message}")
    rescue => exception
      Rails.logger.error("Migration failed: #{exception.message}")
    ensure
      file_migration.update!(
        end_time: Time.current,
        imported_count: patient_count,
        migration_errors: migration_errors.join("\n")
      )

      migration_errors.each { Rails.logger.error(_1) }
      Rails.logger.info("Data migration completed: #{patient_count} patients imported.")
    end
  end
end
