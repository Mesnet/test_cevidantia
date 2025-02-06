# level4.rb
require_relative '../lib/base_level'

class Level4 < BaseLevel
  def run
    {
      "rentals" => @rentals.map do |rental|
        {
          "id" => rental["id"],
          "actions" => compute_actions(rental)
        }
      end
    }.to_json
  end

  private

	def compute_actions(rental)
    price = compute_price_for(rental, { with_discount: true }).to_i
    commissions = compute_commissions(price, rental_duration(rental["start_date"], rental["end_date"]))
    # => { insurance_fee: 100, assistance_fee: 200, drivy_fee: 300 }

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
end
