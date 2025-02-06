require 'json'
require 'pry'
require_relative '../models/car'
require_relative '../models/rental'
require_relative '../models/commission'
require_relative '../models/option'


class Level5
	attr_reader :data

  def initialize(input_data = nil)
		@data = input_data
  end

  def run
		results = rentals.map do |rental|
      {
        id: rental.id,
        actions: rental.actions.map(&:to_h),
				options: rental.options.map(&:type)
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
        distance:   r["distance"],
				options:    rental_options(r["id"])
      )
    end
	end

	def options
		return @options if @options

		@options = (data["options"] || []).map do |option|
			Option.new(
				id: option["id"],
				rental_id: option["rental_id"],
				type: option["type"]
			)
		end
	end

	def find_car(car_id)
		cars.find { |c| c.id == car_id }
	end

	def rental_options(rental_id)
		options.select { |o| o.rental_id == rental_id }
	end
end