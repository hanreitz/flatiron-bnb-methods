module SharedMethods
  extend ActiveSupport::Concern

  def openings(date1, date2)
    unavailable = []
    listings.each do |listing|
      listing.reservations.each do |r|
        date_range = ((r.checkin)..(r.checkout))
        if date_range.include?(date1.to_date) || date_range.include?(date2.to_date)
          unavailable << r.listing
        end
      end
    end
    open_listings = listings - unavailable
  end

  def highest_ratio_res_to_listings
    ratios = {}
    self.all.each do |place|
      if place.listings.count > 0
        r = (place.reservations.count)/(place.listings.count)
        ratios["#{place.name}"] = r
      end
    end
    self.find_by(name: ratios.max_by {|k,v| v}[0])
  end

  def most_res
    res_counts = {}
    self.all.each do |place|
      res_counts["#{place.name}"] = place.reservations.count
    end
    self.find_by(name: res_counts.max_by {|k,v| v}[0])
  end
end