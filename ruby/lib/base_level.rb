require 'json'
require 'date'

class BaseLevel
  def initialize(input_data)
    data = JSON.parse(input_data)
    @cars    = data["cars"]    || []
    @rentals = data["rentals"] || []
  end

  private

  def rental_duration(start_date, end_date)
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  def find_car(id)
    @cars.find { |car| car["id"] == id }
  end

  def compute_price_for(rental, options = {})
    car = find_car(rental["car_id"])
    duration = rental_duration(rental["start_date"], rental["end_date"])

    distance_amount = rental["distance"] * car["price_per_km"]

    time_amount = if options[:with_discount]
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
end