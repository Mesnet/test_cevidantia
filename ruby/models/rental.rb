require 'date'
require_relative 'car'

class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance

  def initialize(id:, car:, start_date:, end_date:, distance:)
    @id         = id
    @car        = car
    @start_date = Date.parse(start_date)
    @end_date   = Date.parse(end_date)
    @distance   = distance

    # Validate date range
    raise "start_date should be before end_date" if @start_date > @end_date
		# Validate car presence
		raise "car should be present" if @car.nil?
  end

  def duration
    (end_date - start_date).to_i + 1
  end

  # Core price calculation (distance + time), possibly with discount
  def price
    time_amount = duration * car.price_per_day

    distance_amount = distance * car.price_per_km
    (time_amount + distance_amount).to_i
  end
end
