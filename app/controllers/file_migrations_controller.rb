class FileMigrationsController < ApplicationController
  def new
  end

  def create_patients
    patient_file = params[:patient_file]

    if patient_file.present?
      ProcessPatientsJob.perform_now(patient_file)
      redirect_to file_migrations_path
    else
      redirect_to new_migration_path, alert: "Please upload the patient information CSV file."
    end
  end

  def create_vitals
    vitals_file = params[:vitals_file]

    if vitals_file.present?
      ProcessVitalsJob.perform_now(vitals_file)
      redirect_to file_migrations_path
    else
      redirect_to new_migration_path, alert: "Please upload the vitals information CSV file."
    end
  end
end
