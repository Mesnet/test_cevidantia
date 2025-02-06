# level1.rb
require_relative '../lib/base_level'

class Level1 < BaseLevel

  def run
    { "rentals" => @rentals.map { |rental| compute_price_for(rental) } }.to_json
  end

  private

  def compute_price_for(rental)
    car = find_car(rental["car_id"])
    duration = rental_duration(rental["start_date"], rental["end_date"])

    distance_amount = rental["distance"] * car["price_per_km"]
    time_amount = duration * car["price_per_day"]

    {
      "id"    => rental["id"],
      "price" => time_amount + distance_amount
    }
  end
end
