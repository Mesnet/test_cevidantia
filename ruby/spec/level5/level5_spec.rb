# spec/level5_spec.rb
require 'json'
require_relative '../../level5/level5'
require_relative '../factories'

RSpec.describe Level5 do
  let(:car_1) {build_car( id: 1, price_per_day: 2000, price_per_km: 10)}
  let(:rental_1) {build_rental( id: 1, car_id: 1, start_date: "2015-12-8", end_date: "2015-12-8", distance: 100)}
  let(:rental_2) {build_rental( id: 2, car_id: 1, start_date: "2015-03-31", end_date: "2015-04-01", distance: 300)}
  let(:rental_3) {build_rental( id: 3, car_id: 1, start_date: "2015-07-3", end_date: "2015-07-14", distance: 1000)}

  let(:options) do
    [
      { "id" => 1, "rental_id" => 1, "type" => "gps" },
      { "id" => 2, "rental_id" => 1, "type" => "baby_seat" },
      { "id" => 3, "rental_id" => 2, "type" => "additional_insurance" }
    ]
  end

  let(:input_data) do
    {
      "cars" => [car_1],
      "rentals" => [rental_1, rental_2, rental_3],
      "options" => options
    }
  end

  subject(:level5) { described_class.new(input_data) }

  describe "#run" do
    let(:parsed_result) { JSON.parse(level5.run) }
    let(:rentals)       { parsed_result["rentals"] }

    context "rental 1" do
      let(:rental) { rentals.find { |r| r["id"] == 1 } }

      it "has options gps + baby_seat" do
        expect(rental["options"]).to contain_exactly("gps", "baby_seat")
      end

      it "has correct actions" do
        actions = rental["actions"]
        # driver => 3700 (from the problem statement)
        driver_action = actions.find { |a| a["who"] == "driver" }
        expect(driver_action["type"]).to eq("debit")
        expect(driver_action["amount"]).to eq(3700)

        # owner => 2800
        owner_action = actions.find { |a| a["who"] == "owner" }
        expect(owner_action["type"]).to eq("credit")
        expect(owner_action["amount"]).to eq(2800)

        # insurance => 450
        insurance_action = actions.find { |a| a["who"] == "insurance" }
        expect(insurance_action["type"]).to eq("credit")
        expect(insurance_action["amount"]).to eq(450)

        # assistance => 100
        assistance_action = actions.find { |a| a["who"] == "assistance" }
        expect(assistance_action["amount"]).to eq(100)

        # drivy => 350
        drivy_action = actions.find { |a| a["who"] == "drivy" }
        expect(drivy_action["amount"]).to eq(350)
      end
    end

    context "rental 2" do
      let(:rental) { rentals.find { |r| r["id"] == 2 } }

      it "has the additional_insurance option" do
        expect(rental["options"]).to contain_exactly("additional_insurance")
      end

      it "has correct actions" do
        actions = rental["actions"]

        driver_action = actions.find { |a| a["who"] == "driver" }
        expect(driver_action["type"]).to eq("debit")
        expect(driver_action["amount"]).to eq(8800)

        owner_action = actions.find { |a| a["who"] == "owner" }
        expect(owner_action["amount"]).to eq(4760)

        insurance_action = actions.find { |a| a["who"] == "insurance" }
        expect(insurance_action["amount"]).to eq(1020)

        assistance_action = actions.find { |a| a["who"] == "assistance" }
        expect(assistance_action["amount"]).to eq(200)

        drivy_action = actions.find { |a| a["who"] == "drivy" }
        expect(drivy_action["amount"]).to eq(2820)
      end
    end

    context "rental 3" do
      let(:rental) { rentals.find { |r| r["id"] == 3 } }

      it "has no options" do
        expect(rental["options"]).to eq([])
      end

      it "has correct actions" do
        actions = rental["actions"]

        driver_action = actions.find { |a| a["who"] == "driver" }
        expect(driver_action["amount"]).to eq(27800)

        owner_action = actions.find { |a| a["who"] == "owner" }
        expect(owner_action["amount"]).to eq(19460)

        insurance_action = actions.find { |a| a["who"] == "insurance" }
        expect(insurance_action["amount"]).to eq(4170)

        assistance_action = actions.find { |a| a["who"] == "assistance" }
        expect(assistance_action["amount"]).to eq(1200)

        drivy_action = actions.find { |a| a["who"] == "drivy" }
        expect(drivy_action["amount"]).to eq(2970)
      end
    end
  end

  context "with file-based data" do
    let(:file_input) do
      File.read(File.join(__dir__, '../../level5/data', 'input.json'))
    end

    let(:expected_output_file) do
      File.read(File.join(__dir__, '../../level5/data', 'expected_output.json'))
    end

    let(:json_expected) { JSON.parse(expected_output_file) }

    it "matches the expected output from file" do
      level = described_class.new(JSON.parse(file_input))
      parsed_result = JSON.parse(level.run)

      expect(parsed_result).to eq(json_expected)
    end
  end
end
