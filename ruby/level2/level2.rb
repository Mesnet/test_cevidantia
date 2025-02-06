require 'json'
require_relative '../models/car'
require_relative '../models/rental'


class Level2
	attr_reader :data

  def initialize(input_data = nil)
		@data = input_data
  end

  def run
    # Compute prices
    results = rentals.map do |rental|
      {
        id: rental.id,
        price: rental.price_with_discount
      }
    end

    return { rentals: results }.to_json
  end

	private

	def cars
		return @cars if @cars

		@cars = (data["cars"] || []).map do |c|
      Car.new(
        id: c["id"],
        price_per_day: c["price_per_day"],
        price_per_km:  c["price_per_km"]
      )
    end

		cars
	end

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

	def find_car(car_id)
		cars.find { |c| c.id == car_id }
	end
end