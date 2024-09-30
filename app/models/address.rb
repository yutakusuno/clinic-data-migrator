class Address < ApplicationRecord
  belongs_to :patient
  
  validates :postal_code, format: { with: /\A[A-Z]\d[A-Z] \d[A-Z]\d\z/, message: ->(object, data) { "#{data[:value]} is not a valid postal code. It must be in the format A1A 1A1." } }, allow_blank: true
  validate :validate_and_convert_province

  before_save :upcase_postal_code

  private

  def upcase_postal_code
    self.postal_code = postal_code.upcase if postal_code.present?
  end

  def validate_and_convert_province
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

    if province_mappings.key?(province)
      self.province = province_mappings[province]
    elsif province_mappings.value?(province)
      # Do nothing, it's already a valid abbreviation
    else
      errors.add(:province, "is not a valid province")
    end
  end
end
