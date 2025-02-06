# level2.rb
require_relative '../lib/base_level'

class Level2 < BaseLevel

  def run
    { rentals: build_rentals }.to_json
  end

  private

  def build_rentals
    @rentals.map do |rental|
      { id: rental["id"],
        price: compute_price_for(rental, { with_discount: true })
      }
    end
  end
end
