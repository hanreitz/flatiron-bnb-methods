class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :through => :reservations, :class_name => "User"
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_save :set_host
  after_destroy :unset_host

  def set_host
    host.update(host: true)
  end

  def unset_host
    if !host.listings.any?
      host.update(host: false)
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
