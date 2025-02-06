# level1.rb
require_relative '../lib/base_level'

class Level1 < BaseLevel

  def run
    { "rentals" => @rentals.map { |rental| compute_price_for(rental) } }.to_json
  end
end
