class Movie < ApplicationRecord
  FLOP_THRESHOLD = 400_000_000
  RATINGS = %w(G PG PG-13 R NC-17)

  validates :name, :released_on, :duration, presence: true
  validates :description, length: { minimum: 20 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  def self.released
    where("released_on <= ?", Time.now).order("released_on desc")
  end

  def self.upcoming
    where("released_on > ?", Time.now).order("released_on asc")
  end

  def self.flopped
    where("total_gross < ?", FLOP_THRESHOLD)
  end

  def self.succeeded
    where("total_gross >= ?", FLOP_THRESHOLD)
  end

  def flop?
    total_gross.blank? || total_gross < FLOP_THRESHOLD
  end

  def success?
    total_gross >= FLOP_THRESHOLD
  end
end
