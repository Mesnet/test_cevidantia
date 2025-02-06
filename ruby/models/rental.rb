require 'date'
require_relative 'car'
require_relative 'commission'
require_relative 'action'

class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance, :options, :with_duration_discount

  def initialize(id:, car:, start_date:, end_date:, distance:, options: [], with_duration_discount: true)
    @id         = id
    @car        = car
    @start_date = Date.parse(start_date)
    @end_date   = Date.parse(end_date)
    @distance   = distance
    @options    = options
    @with_duration_discount = with_duration_discount

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
    time_amount = if with_duration_discount
      discounted_time_price
    else
      duration * car.price_per_day
    end

    distance_amount = distance * car.price_per_km
    (time_amount + distance_amount).to_i
  end

  def price_with_options
    result = price
    options.each do |option|
      result += option.price_per_day * duration
    end
    result
  end

  def commission
    @commission ||= Commission.new(price, duration, options)
  end

  def commissions
    commission.details
  end

  def actions
    return @actions if @actions

    commission_total = commissions.values.sum
    owner_amount = price_with_options - commission_total

    @actions = []
    @actions << Action.new(who: "driver", type: "debit", amount: price_with_options)
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
