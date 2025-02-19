class Movie < ApplicationRecord
  HIT_THRESHOLD = 600_000_000
  FLOP_THRESHOLD = 300_000_000
  RATINGS = %w(G PG PG-13 R NC-17)

  has_many :reviews, dependent: :destroy
  has_many :critics, through: :reviews, source: :user
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  validates :name, :released_on, :duration, presence: true
  validates :description, length: { minimum: 20 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  scope :released, -> { where("released_on <= ?", Time.now).order("released_on desc") }
  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
  scope :recent, -> { where("released_on BETWEEN ? AND ?", Time.now-1.month, Time.now) }
  scope :hits, -> { released.where("total_gross >= ?", HIT_THRESHOLD).order(total_gross: :desc) }
  scope :flops, -> { released.where("total_gross < ?", FLOP_THRESHOLD).order(total_gross: :asc) }

  def flop?
    unless (reviews.count > 50 && average_stars >= 4)
      (total_gross.blank? || total_gross < 225_000_000)
    end
  end

  def hit?
    total_gross >= HIT_THRESHOLD || (reviews.count > 50 && average_stars >= 4)
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (self.average_stars / 5.0) * 100
  end

end
