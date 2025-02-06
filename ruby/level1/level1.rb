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

  private

  def rentals
		return @rentals if @rentals

		@rentals = (data["rentals"] || []).map do |r|
      Rental.new(
        id:         r["id"],
        car:        find_car(r["car_id"]),
        start_date: r["start_date"],
        end_date:   r["end_date"],
        distance:   r["distance"]
      )
    end
	end
end
