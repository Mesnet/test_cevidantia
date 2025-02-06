# level3.rb
require_relative '../lib/base_level'

class Level3 < BaseLevel

  def run
    { "rentals" => @rentals.map do |rental|
      price = compute_price_for(rental, { with_discount: true })
      { id: rental["id"],
        price: price,
        commission: compute_commissions(price, rental_duration(rental["start_date"], rental["end_date"])),
      }
    end }.to_json
  end
end
