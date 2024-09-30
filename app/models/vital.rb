class Vital < ApplicationRecord
  belongs_to :patient

  validates :vital_type, :measurement, :units, presence: true
  validates :units, inclusion: { in: %w(kg lbs cm), message: "%{value} is not a valid unit" }
  validate :measurement_in_valid_range

  def measurement_in_valid_range
    if measurement <= 0
      errors.add(:measurement, "must be greater than 0")
    end
  end
end
