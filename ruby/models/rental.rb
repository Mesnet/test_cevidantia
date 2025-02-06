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
  def price(with_discount: false)
    time_amount = if with_discount
      discounted_time_price
    else
      duration * car.price_per_day
    end

    distance_amount = distance * car.price_per_km
    (time_amount + distance_amount).to_i
  end

  def price_with_discount
    price(with_discount: true)
  end

  private

  def discounted_time_price
    total = 0.0
    (1..duration).each do |day|
      daily_full_price = car.price_per_day.to_f
      daily_discounted_price = case day
      when 1      then daily_full_price
      when 2..4   then daily_full_price * 0.9
      when 5..10  then daily_full_price * 0.7
      else            daily_full_price * 0.5
      end
      total += daily_discounted_price
    end
    total
  end
end
