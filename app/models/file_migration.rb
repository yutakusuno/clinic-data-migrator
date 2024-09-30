class FileMigration < ApplicationRecord
  validates :file_name, :start_time, presence: true
  validates :imported_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def duration
    return nil unless end_time
    end_time - start_time
  end
end
