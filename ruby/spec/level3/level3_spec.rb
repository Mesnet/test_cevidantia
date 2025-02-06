# spec/level3_spec.rb
require 'json'
require_relative '../../level3/main'
require_relative '../factories'

RSpec.describe Level3 do
  # Single car for all rentals
  let(:car_1) { build_car( id: 1, price_per_day: 2000, price_per_km: 10) }
  let(:rental_1) { build_rental( id: 1, car_id: 1, start_date: "2015-12-8", end_date: "2015-12-8", distance: 100) }
  let(:rental_2) { build_rental( id: 2, car_id: 1, start_date: "2015-03-31", end_date: "2015-04-01", distance: 300) }
  let(:rental_3) { build_rental( id: 3, car_id: 1, start_date: "2015-07-03", end_date: "2015-07-14", distance: 1000) }

  let(:input_data) do
    {
      "cars"    => [car_1],
      "rentals" => [rental_1, rental_2, rental_3]
    }.to_json
  end

  subject(:level3) { described_class.new(input_data) }

  describe "#run" do
    let(:parsed_result) { JSON.parse(level3.run) }
    let(:rentals)       { parsed_result["rentals"] }

    it "computes correct price & commissions for rental #1" do
      r1 = rentals.find { |r| r["id"] == 1 }
      expect(r1["price"]).to eq(3000)

      commission = r1["commission"]
      expect(commission["insurance_fee"]).to   eq(450)
      expect(commission["assistance_fee"]).to  eq(100)
      expect(commission["drivy_fee"]).to       eq(350)
    end

    it "computes correct price & commissions for rental #2" do
      r2 = rentals.find { |r| r["id"] == 2 }
      expect(r2["price"]).to eq(6800)

      commission = r2["commission"]
      expect(commission["insurance_fee"]).to   eq(1020)
      expect(commission["assistance_fee"]).to  eq(200)
      expect(commission["drivy_fee"]).to       eq(820)
    end

    it "computes correct price & commissions for rental #3" do
      r3 = rentals.find { |r| r["id"] == 3 }
      expect(r3["price"]).to eq(27800)

      commission = r3["commission"]
      expect(commission["insurance_fee"]).to   eq(4170)
      expect(commission["assistance_fee"]).to  eq(1200)
      expect(commission["drivy_fee"]).to       eq(2970)
    end
  end

  context "with file-based data" do
    let(:file_input) do
      File.read(File.join(__dir__, 'data', 'input.json'))
    end

    let(:expected_output_file) do
      File.read(File.join(__dir__, 'data', 'expected_output.json'))
    end

    let(:json_expected) { JSON.parse(expected_output_file) }

    it "matches the expected output from file" do
      level = described_class.new(file_input)
      parsed_result = JSON.parse(level.run)

      expect(parsed_result).to eq(json_expected)
    end
  end
end
