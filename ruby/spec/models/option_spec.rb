# spec/models/option_spec.rb
require_relative '../../models/option'

RSpec.describe Option do
  describe "#initialize" do
    it "creates a valid option with a known type" do
      opt = Option.new(id: 1, rental_id: 10, type: "gps")
      expect(opt.id).to eq(1)
      expect(opt.rental_id).to eq(10)
      expect(opt.type).to eq("gps")
    end

    it "raises an error if given an unknown type" do
      expect {
        Option.new(id: 2, rental_id: 10, type: "unknown_option")
      }.to raise_error(RuntimeError, /type should be one of gps, baby_seat, additional_insurance/)
    end
  end

  describe "#price_per_day" do
    it "returns 500 for gps" do
      opt = Option.new(id: 1, rental_id: 10, type: "gps")
      expect(opt.price_per_day).to eq(500)
    end

    it "returns 200 for baby_seat" do
      opt = Option.new(id: 2, rental_id: 10, type: "baby_seat")
      expect(opt.price_per_day).to eq(200)
    end

    it "returns 1000 for additional_insurance" do
      opt = Option.new(id: 3, rental_id: 10, type: "additional_insurance")
      expect(opt.price_per_day).to eq(1000)
    end
  end
end
