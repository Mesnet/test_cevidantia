require_relative '../lib/base_level'

class Level1 < BaseLevel

  def run
    # Compute prices
    rentals.each { |rental| rental.duration_discount_enabled = false }
    results = rentals.map do |rental|
      {
        id: rental.id,
        price: rental.price
      }
    end

    return { rentals: results }.to_json
  end

end
