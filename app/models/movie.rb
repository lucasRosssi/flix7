class Movie < ApplicationRecord
  @@flop_threshold = 400_000_000

  def self.released
    where("released_on <= ?", Time.now).order("released_on desc")
  end

  def self.upcoming
    where("released_on > ?", Time.now).order("released_on asc")
  end

  def self.flopped
    where("total_gross < ?", @@flop_threshold)
  end

  def self.succeeded
    where("total_gross >= ?", @@flop_threshold)
  end

  def flop?
    total_gross.blank? || total_gross < @@flop_threshold
  end

  def success?
    total_gross >= @@flop_threshold
  end
end
