# spec/level4_spec.rb
require 'json'
require_relative '../level4/main'
require_relative 'factories'

RSpec.describe Level4 do
  let(:car_1) { build_car(id: 1, price_per_day: 2000, price_per_km: 10) }
  let(:rental_1) { build_rental(id: 1, car_id: 1, start_date: "2015-12-8", end_date: "2015-12-8", distance: 100) }
  let(:rental_2) { build_rental(id: 2, car_id: 1, start_date: "2015-03-31", end_date: "2015-04-01", distance: 300) }
  let(:rental_3) { build_rental(id: 3, car_id: 1, start_date: "2015-07-3", end_date: "2015-07-14", distance: 1000) }

  let(:input_data) do
    {
      "cars"    => [car_1],
      "rentals" => [rental_1, rental_2, rental_3]
    }
  end

  subject(:level4) { described_class.new(input_data.to_json) }

  describe "#run" do
    let(:parsed_result) { JSON.parse(level4.run) }
    let(:rentals)       { parsed_result["rentals"] }

    context "rental #1 actions" do
      let(:actions) { rentals.find { |r| r["id"] == 1 }["actions"] }

      it "debits the driver correctly" do
        driver_action = actions.find { |a| a["who"] == "driver" }
        expect(driver_action["type"]).to eq("debit")
        expect(driver_action["amount"]).to eq(3000)
      end

      it "credits the owner correctly" do
        owner_action = actions.find { |a| a["who"] == "owner" }
        expect(owner_action["type"]).to eq("credit")
        expect(owner_action["amount"]).to eq(2100)
      end

      it "credits insurance, assistance and drivy" do
        $debug = true
        insurance = actions.find { |a| a["who"] == "insurance" }
        assistance = actions.find { |a| a["who"] == "assistance" }
        drivy = actions.find { |a| a["who"] == "drivy" }

        expect(insurance["type"]).to eq("credit")
        expect(insurance["amount"]).to eq(450)

        expect(assistance["type"]).to eq("credit")
        expect(assistance["amount"]).to eq(100)

        expect(drivy["type"]).to eq("credit")
        expect(drivy["amount"]).to eq(350)
        $debug = false
      end
    end

    context "rental #2 actions" do
      let(:actions) { rentals.find { |r| r["id"] == 2 }["actions"] }

      it "debits the driver correctly" do
        driver_action = actions.find { |a| a["who"] == "driver" }
        expect(driver_action["type"]).to eq("debit")
        expect(driver_action["amount"]).to eq(6800)
      end

      it "credits the owner correctly" do
        owner_action = actions.find { |a| a["who"] == "owner" }
        expect(owner_action["type"]).to eq("credit")
        expect(owner_action["amount"]).to eq(4760)
      end

      it "credits insurance, assistance, and drivy" do
        insurance = actions.find { |a| a["who"] == "insurance" }
        assistance = actions.find { |a| a["who"] == "assistance" }
        drivy = actions.find { |a| a["who"] == "drivy" }

        expect(insurance["type"]).to eq("credit")
        expect(insurance["amount"]).to eq(1020)

        expect(assistance["type"]).to eq("credit")
        expect(assistance["amount"]).to eq(200)

        expect(drivy["type"]).to eq("credit")
        expect(drivy["amount"]).to eq(820)
      end
    end

    context "rental #3 actions" do
      let(:actions) { rentals.find { |r| r["id"] == 3 }["actions"] }

      it "debits the driver correctly" do
        driver_action = actions.find { |a| a["who"] == "driver" }
        expect(driver_action["type"]).to eq("debit")
        expect(driver_action["amount"]).to eq(27800)
      end

      it "credits the owner correctly" do
        owner_action = actions.find { |a| a["who"] == "owner" }
        expect(owner_action["type"]).to eq("credit")
        expect(owner_action["amount"]).to eq(19460)
      end

      it "credits insurance, assistance, and drivy" do
        insurance = actions.find { |a| a["who"] == "insurance" }
        assistance = actions.find { |a| a["who"] == "assistance" }
        drivy = actions.find { |a| a["who"] == "drivy" }

        expect(insurance["type"]).to eq("credit")
        expect(insurance["amount"]).to eq(4170)

        expect(assistance["type"]).to eq("credit")
        expect(assistance["amount"]).to eq(1200)

        expect(drivy["type"]).to eq("credit")
        expect(drivy["amount"]).to eq(2970)
      end
    end
  end
end
