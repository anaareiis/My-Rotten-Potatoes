class Movie < ApplicationRecord
  validates :title, presence: true, uniqueness: { case_sensitive: false, message: "already exists in the database" }, length: { minimum: 1, maximum: 200, message: "must be between 1 and 200 characters" }
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5, message: "must be an integer between 0 and 5" }
  validates :description, presence: true, length: { minimum: 10, maximum: 1000, message: "must be between 10 and 1000 characters" }
  validates :release_date, presence: true, comparison: { less_than_or_equal_to: Date.today, message: "cannot be in the future" }
  
  validate :release_date_is_reasonable

  def movies_with_same_director
    Movie.where(director: director).where.not(id: id)
  end

  private
  
  def release_date_is_reasonable
    if release_date.present? && release_date < Date.new(1800, 1, 1)
      errors.add(:release_date, "cannot be before 1800")
    end
  end
end