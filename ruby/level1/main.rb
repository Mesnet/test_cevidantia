# level1.rb
require_relative '../lib/base_level'

class Level1 < BaseLevel

  def run
    { "rentals" => @rentals.map do |rental|
      { id: rental["id"],
        price: compute_price_for(rental)
      }
    end }.to_json
  end
end
