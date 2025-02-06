# level4.rb
require_relative '../lib/base_level'

class Level4 < BaseLevel
  def run
    { rentals: build_rentals }.to_json
  end

  private

  def build_rentals
    @rentals.map do |rental|
      {
        "id" => rental["id"],
        "actions" => compute_actions(rental)
      }
    end
  end
end
