# spec/level1_spec.rb
require_relative '../../level1/level1'
require_relative '../factories'   # load our custom factory methods

RSpec.describe Level1 do
  # Use our factory methods
  let(:car_1) { build_car_payload(id: 1, price_per_day: 2000, price_per_km: 10) }
  let(:car_2) { build_car_payload(id: 2, price_per_day: 3000, price_per_km: 15) }

  let(:rental_1) { build_rental_payload(id: 1, car_id: 1, start_date: "2025-02-01", end_date: "2025-02-01", distance: 100) }
  let(:rental_2) { build_rental_payload(id: 2, car_id: 2, start_date: "2025-02-01", end_date: "2025-02-03", distance: 200) }

  let(:input_data) do
    {
      "cars"    => [car_1, car_2],
      "rentals" => [rental_1, rental_2]
    }
  end

  subject { described_class.new(input_data) }

  describe "#run" do
    let(:result) { JSON.parse(subject.run) }

    it "computes correct price for rental_1" do
      # 1 day => 1*2000 + (100*10) = 3000
      rental_1_result = result["rentals"].find { |r| r["id"] == rental_1["id"] }
      expect(rental_1_result["price"]).to eq(3000)
    end

    it "computes correct price for rental_2" do
      # 3 days => 3*3000 + (200*15) = 9000 + 3000 = 12000
      rental_2_result = result["rentals"].find { |r| r["id"] == rental_2["id"] }
      expect(rental_2_result["price"]).to eq(12000)
    end
  end

  context "with file-based data" do
    let(:file_input) do
      File.read(File.join(__dir__, '../../level1/data', 'input.json'))
    end

    let(:expected_output_file) do
      File.read(File.join(__dir__, '../../level1/data', 'expected_output.json'))
    end

    let(:json_expected) { JSON.parse(expected_output_file) }

    it "matches the expected output from file" do
      level = described_class.new(JSON.parse(file_input))
      parsed_result = JSON.parse(level.run)

      expect(parsed_result).to eq(json_expected)
    end
  end
end
