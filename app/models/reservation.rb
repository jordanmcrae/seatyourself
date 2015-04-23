class Reservation < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  validates :party_size, numericality: [only_integer: true]
  validate :date_is_valid?


  private

  def date_is_valid?
    if !date.is_a?(Date)
      errors.add(:date, 'must be a valid date')
    end
  end
end
