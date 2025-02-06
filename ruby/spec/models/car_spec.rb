# spec/models/car_spec.rb
require_relative '../../models/car'

RSpec.describe Car do
  describe "#initialize" do
    it "sets the id, price_per_day, price_per_km" do
      car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
      expect(car.id).to eq(1)
      expect(car.price_per_day).to eq(2000)
      expect(car.price_per_km).to eq(10)
    end
  end
end
