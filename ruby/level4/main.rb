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
end
