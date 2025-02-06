# spec/models/rental_spec.rb
require_relative '../../models/car'
require_relative '../../models/option'
require_relative '../../models/commission'
require_relative '../../models/action'
require_relative '../../models/rental'

RSpec.describe Rental do
  let(:car) { Car.new(id: 1, price_per_day: 2000, price_per_km: 10) }

  let(:gps_option) do
    Option.new(id: 99, rental_id: 1, type: "gps")
  end

  let(:baby_seat_option) do
    Option.new(id: 100, rental_id: 1, type: "baby_seat")
  end

  # A valid rental spanning 3 days (2025-02-01 to 2025-02-03)
  let(:rental) do
    described_class.new(
      id: 1,
      car: car,
      start_date: "2025-02-01",
      end_date:   "2025-02-03",
      distance:   100,
      options:    []
    )
  end

  describe "initialization" do
    it "raises an error if start_date > end_date" do
      expect {
        described_class.new(
          id: 1,
          car: car,
          start_date: "2025-02-10",
          end_date:   "2025-02-01",
          distance:   50
        )
      }.to raise_error(RuntimeError, /start_date should be before end_date/)
    end

    it "raises an error if car is not a Car instance" do
      expect {
        described_class.new(
          id: 2,
          car: nil,
          start_date: "2025-02-01",
          end_date:   "2025-02-02",
          distance:   50
        )
      }.to raise_error(RuntimeError, /car should be present/)
    end
  end

  describe "#duration" do
    it "returns the inclusive number of days" do
      expect(rental.duration).to eq(3)  # 1..3 => 3 days
    end
  end

  describe "#price" do
    context "with discount enabled (default)" do
      # day1 => 2000
      # days2..3 => 10% discount => 1800 each => total time = 2000 + 1800 + 1800 = 5600
      # distance = 100 * 10 => 1000
      # total = 5600 + 1000 = 6600
      it "applies the day-by-day discount" do
        expect(rental.price).to eq(6600)
      end
    end

    context "with discount disabled" do
      # 3 days => 3*2000=6000 + distance(1000)=7000
      it "computes price without discount" do
        rental.duration_discount_enabled = false
        expect(rental.price).to eq(7000)
      end
    end
  end

  describe "#price_with_options" do
    context "no options" do
      it "equals #price if no options" do
        # from earlier example => 6600
        expect(rental.price_with_options).to eq(rental.price)
      end
    end

    context "with gps and baby_seat" do
      # gps => 500/day, baby_seat => 200/day => total extra=700/day
      # 3 days => 2100
      # base=6600 => final=6600+2100=8700
      it "adds the per-day cost of the options" do
        rental.options << gps_option
        rental.options << baby_seat_option
        expect(rental.price_with_options).to eq(8700)
      end
    end
  end

  describe "#commissions" do
    # Commission is 30% of base price => 30% of 6600=1980
    # insurance=990, assistance=3days*100=300 => leftover=690
    # If no additional_insurance => drivy=690
    it "returns the correct fees as a hash" do
      expect(rental.commissions).to eq({
        insurance_fee: 990,
        assistance_fee: 300,
        drivy_fee: 690
      })
    end

    # If we add an additional_insurance => +1000/day => +3000 to drivy
    it "adds extra to drivy if there's an additional_insurance option" do
      rental.options << Option.new(id: 101, rental_id: 1, type: "additional_insurance")
      # base commission: 1980 => insurance=990, assistance=300 => leftover=690
      # plus additional insurance => 3days => +3000 => final drivy=3690
      expect(rental.commissions).to eq({
        insurance_fee: 990,
        assistance_fee: 300,
        drivy_fee: 3690
      })
    end
  end

  describe "#actions" do
    # base price_with_options=6600 for 3-day, no option
    # total commission=1980 => leftover=4620 => owner=4620
    context "no options" do
      it "includes driver (debit) and owner, insurance, assistance, drivy (credit)" do
        actions = rental.actions
        expect(actions.size).to eq(5)

        driver_action = actions.find { |a| a.who == "driver" }
        expect(driver_action.type).to eq("debit")
        expect(driver_action.amount).to eq(6600)

        owner_action = actions.find { |a| a.who == "owner" }
        expect(owner_action.type).to eq("credit")
        # base_price_with_options=6600 => commissions=1980 => leftover=4620
        expect(owner_action.amount).to eq(4620)

        insurance_action = actions.find { |a| a.who == "insurance" }
        expect(insurance_action.type).to eq("credit")
        expect(insurance_action.amount).to eq(990)

        assistance_action = actions.find { |a| a.who == "assistance" }
        expect(assistance_action.amount).to eq(300)

        drivy_action = actions.find { |a| a.who == "drivy" }
        expect(drivy_action.amount).to eq(690)
      end
    end

    context "with gps option" do
      # base=6600 + (gps=500/day=1500) => 8100
      # commission still 1980 from base => leftover=6600-1980=4620 => add GPS to owner => +1500 => 6120
      it "increases the driver debit and owner credit" do
        rental.options << gps_option
        actions = rental.actions

        driver_action = actions.find { |a| a.who == "driver" }
        expect(driver_action.amount).to eq(8100)  # base + gps

        owner_action = actions.find { |a| a.who == "owner" }
        expect(owner_action.amount).to eq(6120)   # 4620 (base leftover) + 1500
      end
    end
  end
end
