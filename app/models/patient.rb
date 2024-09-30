class Patient < ApplicationRecord
  has_many :addresses
  has_many :vitals
  has_many :health_identifiers

  validates :first_name, :last_name, :phone_number, :date_of_birth, :sex, presence: true
  validates :phone_number, format: { with: /\A\d{3}-\d{3}-\d{4}\z/, message: ->(object, data) { "#{data[:value]} is not a valid phone number format. It must be in format xxx-xxx-xxxx." } }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: ->(object, data) { "#{data[:value]} is not a valid email format." } }

  # Valid options for sex: M (Male), F (Female), NB (Non-Binary), U (Undisclosed)
  validates :sex, inclusion: { in: %w(M F NB U m f nb u), message: "%{value} is not a valid sex" }

  before_save :upcase_sex
  before_validation :strip_email

  private

  def strip_email
    self.email = email.strip if email.present?
  end

  def upcase_sex
    self.sex = sex.upcase if sex.present?
  end
end
