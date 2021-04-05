class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :accepted
  validate :past_checkout

  private

  def accepted
    if reservation && reservation.status != "accepted"
      errors.add(:reservation, "This reservation has not been accepted. You can only review an accepted reservation.")
    end
  end

  def past_checkout
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "This reservation has not yet ended. Please review after checkout.")
    end
  end


end
