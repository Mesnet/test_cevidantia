require 'json'
require 'date'

class BaseLevel
  def initialize(input_data)
    data = JSON.parse(input_data)
    @cars    = data["cars"]    || []
    @rentals = data["rentals"] || []
    @options = data["options"] || []
  end

  private

  def rental_duration(start_date, end_date)
    from_date = Date.parse(start_date)
    to_date = Date.parse(end_date)

    if from_date > to_date
      raise "start_date should be before end_date (#{start_date} > #{end_date})"
    end

    (to_date - from_date).to_i + 1
  end

  def find_car(id)
    car = @cars.find { |car| car["id"] == id }
    raise "Car with id=#{id} not found" if car.nil?

    car
  end

  def rental_options(rental)
    @options.select { |option| option["rental_id"] == rental["id"] }
  end

  def compute_price_for(rental, opts = {})
    car = find_car(rental["car_id"])
    duration = rental_duration(rental["start_date"], rental["end_date"])

    distance_amount = rental["distance"] * car["price_per_km"]

    time_amount = if opts[:with_discount]
			amount_with_discount(duration, car["price_per_day"])
		else
			duration * car["price_per_day"]
		end

    (time_amount + distance_amount).to_i
  end


	def amount_with_discount(duration, price_per_day)
		discounted_time_amount = 0
		(1..duration).each do |day|
      daily_full_price = price_per_day.to_f

      daily_discounted_price = case day
      when 1
        daily_full_price
      when 2..4
        daily_full_price * 0.9
      when 5..10
        daily_full_price * 0.7
      else
        daily_full_price * 0.5
      end

      discounted_time_amount += daily_discounted_price
    end

		discounted_time_amount
	end

  def compute_commissions(price, duration)
    commission_total = (price * 0.3).to_i  # 30% of the price

    insurance_fee   = (commission_total / 2).to_i
    assistance_fee  = duration * 100 # 1€/day
    drivy_fee       = commission_total - insurance_fee - assistance_fee

    {
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee,
      drivy_fee: drivy_fee
    }
  end

  def compute_actions(rental, opts = {})
    price = compute_price_for(rental, { with_discount: true }).to_i
    duration = rental_duration(rental["start_date"], rental["end_date"])
    commissions = compute_commissions(price, duration)
    # => { insurance_fee: 100, assistance_fee: 200, drivy_fee: 300 }

    if opts[:with_options]
      rental_options(rental).each do |option|
        case option["type"]
        when "gps"
          price += duration * 500
        when "baby_seat"
          price += duration * 200
        when "additional_insurance"
          additional_insurance_amount = duration * 1000
          price += additional_insurance_amount
          commissions[:drivy_fee] += additional_insurance_amount
        else
          raise "Unknown option type #{option["type"]}"
        end
      end
    end

    commission_total = commissions.values.sum
    owner_amount = price - commission_total

    actions = [
      {
        "who" => "driver",
        "type" => "debit",
        "amount" => price
      },
      {
        "who" => "owner",
        "type" => "credit",
        "amount" => owner_amount
      }
    ]

    commissions.each do |key, value|
      who = key.to_s.gsub("_fee", "")

      actions << {
        "who" => who,
        "type" => "credit",
        "amount" => value
      }
    end

    actions
  end

  def build_rentals
    raise "Not implemented"
  end
end