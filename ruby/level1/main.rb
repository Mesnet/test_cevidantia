# level1.rb
require_relative '../lib/base_level'

class Level1 < BaseLevel

  def run
    { rentals: build_rentals }.to_json
  end

  private

  def build_rentals
    @rentals.map do |rental|
      { id: rental["id"],
        price: compute_price_for(rental)
      }
    end
  end
end
