# spec/base_level_raises_spec.rb
require 'json'
require_relative '../lib/base_level'
require_relative 'factories'

RSpec.describe BaseLevel do
  let(:car_1) do
    build_car(id: 1, price_per_day: 2000, price_per_km: 10)
  end

  context "when start_date is after end_date" do
    let(:bad_rental) do
      build_rental(
        id: 1,
        car_id: 1,
        start_date: "2025-12-10",
        end_date:   "2025-12-01",  # earlier than start => invalid
        distance:   100
      )
    end

    let(:input_data) do
      {
        "cars"    => [car_1],
        "rentals" => [bad_rental]
      }.to_json
    end

    subject(:base_level) { described_class.new(input_data) }

    it "raises an error about invalid date range" do
      expect {
        base_level.send(:compute_actions, bad_rental)
      }.to raise_error(RuntimeError, /start_date should be before end_date/)
    end
  end

  context "when the car referenced by a rental is not found" do
    let(:rental_with_unknown_car) do
      build_rental(
        id: 1,
        car_id: 999,  # no such car in the list
        start_date: "2025-02-01",
        end_date:   "2025-02-02",
        distance:   50
      )
    end

    let(:input_data) do
      {
        "cars"    => [], # empty => we won't find car_id=999
        "rentals" => [rental_with_unknown_car]
      }.to_json
    end

    subject(:base_level) { described_class.new(input_data) }

    it "raises an error that the car is not found" do
      expect {
        base_level.send(:compute_actions, rental_with_unknown_car)
      }.to raise_error(RuntimeError, /Car with id=999 not found/)
    end
  end

  context "when a rental has an unknown option type" do
    let(:valid_rental) do
      build_rental(
        id: 1,
        car_id: 1,
        start_date: "2025-02-01",
        end_date:   "2025-02-02",
        distance:   100
      )
    end

    let(:unknown_option) do
      { "id" => 42, "rental_id" => 1, "type" => "teleporter" }
    end

    let(:input_data) do
      {
        "cars"    => [car_1],
        "rentals" => [valid_rental],
        "options" => [unknown_option]
      }.to_json
    end

    subject(:base_level) { described_class.new(input_data) }

    it "raises an error for unknown option type" do
      expect {
        base_level.send(:compute_actions, valid_rental, { with_options: true })
      }.to raise_error(RuntimeError, /Unknown option type/)
    end
  end

  # -----------
  # HAPPY PATH
  # -----------
  context "when everything is valid" do
    let(:valid_rental) do
      build_rental(
        id: 1,
        car_id: 1,
        start_date: "2025-02-01",
        end_date:   "2025-02-02",  # valid
        distance:   100
      )
    end

    let(:gps_option) do
      { "id" => 99, "rental_id" => 1, "type" => "gps" }
    end

    let(:input_data) do
      {
        "cars"    => [car_1],
        "rentals" => [valid_rental],
        "options" => [gps_option]
      }.to_json
    end

    subject(:base_level) { described_class.new(input_data) }

    it "does not raise an error and returns a list of actions" do
      expect {
        @actions = base_level.send(:compute_actions, valid_rental, { with_options: true })
      }.not_to raise_error

      expect(@actions).to be_an(Array)
    end
  end
end
