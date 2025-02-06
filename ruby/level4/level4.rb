require_relative '../lib/base_level'

class Level4 < BaseLevel

  def run
    results = rentals.map do |rental|
      {
        id: rental.id,
        actions: rental.actions.map(&:to_h)
      }
    end

    return { rentals: results }.to_json
  end
end
