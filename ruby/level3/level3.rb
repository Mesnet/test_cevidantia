require_relative '../lib/base_level'

class Level3 < BaseLevel

  def run
    results = rentals.map do |rental|
      {
        id: rental.id,
        price: rental.price,
        commission: rental.commission.details,
      }
    end

    return { rentals: results }.to_json
  end

end
