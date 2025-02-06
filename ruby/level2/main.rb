# level2.rb
require_relative '../lib/base_level'

class Level2 < BaseLevel

  def run
    { "rentals" => @rentals.map do |rental|
      { id: rental["id"],
        price: compute_price_for(rental, { with_discount: true })
      }
    end }.to_json
  end
end
