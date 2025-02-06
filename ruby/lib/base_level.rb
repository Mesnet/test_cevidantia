require 'json'
require 'date'

class BaseLevel
  def initialize(input_data)
    data = JSON.parse(input_data)
    @cars    = data["cars"]    || []
    @rentals = data["rentals"] || []
  end

  def rental_duration(start_date, end_date)
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  def find_car(id)
    @cars.find { |car| car["id"] == id }
  end
end