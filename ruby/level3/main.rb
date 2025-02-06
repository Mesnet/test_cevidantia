# level3.rb
require_relative '../lib/base_level'

class Level3 < BaseLevel

  def run
    { "rentals" => @rentals.map do |rental|
      price = compute_price_for(rental, { with_discount: true })
      { id: rental["id"],
        price: price,
        commission: compute_commissions(price, rental_duration(rental["start_date"], rental["end_date"])),
      }
    end }.to_json
  end

  private

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
