class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :is_not_host, :is_available, :in_before_out

  def duration
    (checkin..checkout).to_a.size - 1
  end

  def total_price
    duration * listing.price
  end

  private

  def is_not_host
    if listing.host == guest
      errors.add(:guest_id, "You cannot book your own listing.")
    end
  end

  def is_available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      date_range = r.checkin..r.checkout
      if date_range.include?(checkin) || date_range.include?(checkout)
        errors.add(:guest_id, "Sorry, this listing is not available during the requested stay.")
      end
    end
  end

  def in_before_out
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Check-in must be before check-out.")
    end
  end
end
