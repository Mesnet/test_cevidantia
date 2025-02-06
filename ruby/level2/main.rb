# level2.rb
require_relative '../lib/base_level'

class Level2 < BaseLevel

  def run
    { "rentals" => @rentals.map { |rental| compute_price_for(rental, { with_discount: true }) } }.to_json
  end
end
