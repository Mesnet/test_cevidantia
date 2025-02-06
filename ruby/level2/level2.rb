require_relative '../lib/base_level'

class Level2 < BaseLevel

  def run
    # Compute prices
    results = rentals.map do |rental|
      {
        id: rental.id,
        price: rental.price
      }
    end

    return { rentals: results }.to_json
  end
end
