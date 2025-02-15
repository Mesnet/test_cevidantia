# spec/level2_spec.rb
require 'json'
require_relative '../../level2/level2'
require_relative '../factories'  # Load our build_car_payload / build_rental_payload methods

RSpec.describe Level2 do
  # Create the car(s) using the factory method
  let(:car_1) { build_car_payload( id: 1, price_per_day: 2000, price_per_km: 10) }

  # Create each rental using the factory method
  let(:rental_1) { build_rental_payload( id: 1, car_id: 1, start_date: "2015-12-8", end_date: "2015-12-8", distance: 100) }
  let(:rental_2) { build_rental_payload( id: 2, car_id: 1, start_date: "2015-03-31", end_date: "2015-04-01", distance: 300) }
  let(:rental_3) { build_rental_payload( id: 3, car_id: 1, start_date: "2015-07-3", end_date: "2015-07-14", distance: 1000) }

  let(:input_data) do
    {
      "cars" => [car_1],
      "rentals" => [rental_1, rental_2, rental_3]
    }
  end

  # Instantiate the Level2 class with the JSON input
  subject { described_class.new(input_data) }

  describe "#run" do
    # Parse the result from JSON
    let(:result) { JSON.parse(subject.run) }

    it "computes the correct price for rental id=1" do
      rental_1_result = result["rentals"].find { |r| r["id"] == 1 }
      expect(rental_1_result["price"]).to eq(3000)
    end

    it "computes the correct price for rental id=2" do
      rental_2_result = result["rentals"].find { |r| r["id"] == 2 }
      expect(rental_2_result["price"]).to eq(6800)
    end

    it "computes the correct price for rental id=3" do
      rental_3_result = result["rentals"].find { |r| r["id"] == 3 }
      expect(rental_3_result["price"]).to eq(27800)
    end
  end

  context "with file-based data" do
    let(:file_input) do
      File.read(File.join(__dir__, '../../level2/data', 'input.json'))
    end

    let(:expected_output_file) do
      File.read(File.join(__dir__, '../../level2/data', 'expected_output.json'))
    end

    let(:json_expected) { JSON.parse(expected_output_file) }

    it "matches the expected output from file" do
      level = described_class.new(JSON.parse(file_input))
      parsed_result = JSON.parse(level.run)

      expect(parsed_result).to eq(json_expected)
    end
  end
end
