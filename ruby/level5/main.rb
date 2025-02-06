# level5.rb
require_relative '../lib/base_level'

class Level5 < BaseLevel
  def run
    { rentals: build_rentals }.to_json
  end

  private

  def build_rentals
    @rentals.map do |rental|
      {
        "id" => rental["id"],
        "options" => rental_options(rental).map { |h| h["type"] },
        "actions" => compute_actions(rental, { with_options: true })
      }
    end
  end
end
