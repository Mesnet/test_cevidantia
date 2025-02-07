require 'date'
require_relative 'car'
require_relative 'commission'
require_relative 'action'

class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance, :options
  attr_accessor :duration_discount_enabled

  def initialize(id:, car:, start_date:, end_date:, distance:, options: [])
    @id         = id
    @car        = car
    @start_date = Date.parse(start_date)
    @end_date   = Date.parse(end_date)
    @distance   = distance
    @options    = options
    @duration_discount_enabled = true

    # Validate date range
    raise "start_date should be before end_date" if @start_date > @end_date
		# Validate car presence
		raise "car should be present" if !@car.is_a?(Car)
  end

  def duration
    (end_date - start_date).to_i + 1
  end

  # Core price calculation (distance + time), possibly with discount, possibly with options
  def price(with_options: true)
    time_amount = if duration_discount_enabled
      discounted_time_price
    else
      duration * car.price_per_day
    end

    distance_amount = distance * car.price_per_km
    result = (time_amount + distance_amount).to_i

    if with_options
      options.each do |option|
        result += option.price_per_day * duration
      end
    end

    result
  end

  def commission
    price_without_options = price(with_options: false)
    @commission ||= Commission.new(price_without_options, duration, options)
  end

  def commissions
    commission.details
  end

  def actions
    return @actions if @actions

    commission_total = commissions.values.sum
    owner_amount = price - commission_total

    @actions = []
    @actions << Action.new(who: "driver", type: "debit", amount: price)
    @actions << Action.new(who: "owner", amount: owner_amount)

    commissions.each do |key, value|
      # Convert key to string and remove "_fee" suffix
      # Ex : "insurance_fee" => "insurance"
      who = key.to_s.gsub("_fee", "")

      @actions << Action.new(who: who, amount: value)
    end

    @actions
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
