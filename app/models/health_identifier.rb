class HealthIdentifier < ApplicationRecord
  belongs_to :patient
  
  validate :validate_and_convert_health_identifier_number
  validate :validate_and_convert_health_identifier_province_of_origin
  validates :province_of_origin, presence: true
  validates :identifier_number, presence: true, uniqueness: { scope: :province_of_origin }

  private

  def validate_and_convert_health_identifier_number
    if identifier_number.to_s =~ /\A\d+\z/
      self.identifier_number = identifier_number.to_i
    else
      errors.add(:identifier_number, "must be a valid number string")
    end
  end

  def validate_and_convert_health_identifier_province_of_origin
    province_mappings = {
      "British Columbia" => "BC",
      "Alberta" => "AB",
      "Saskatchewan" => "SK",
      "Manitoba" => "MB",
      "Ontario" => "ON",
      "Quebec" => "QC",
      "New Brunswick" => "NB",
      "Nova Scotia" => "NS",
      "Prince Edward Island" => "PE",
      "Newfoundland and Labrador" => "NL",
      "Yukon" => "YT",
      "Northwest Territories" => "NT",
      "Nunavut" => "NU"
    }

    if province_mappings.key?(province_of_origin)
      self.province_of_origin = province_mappings[province_of_origin]
    elsif province_mappings.value?(province_of_origin)
      # Do nothing, it's already a valid abbreviation
    else
      errors.add(:province_of_origin, "is not a valid province")
    end
  end
end
