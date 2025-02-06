# spec/models/commission_spec.rb
require_relative '../../models/option'
require_relative '../../models/commission'

RSpec.describe Commission do
  let(:no_options) { [] }
  let(:insurance_option) do
    Option.new(id: 99, rental_id: 1, type: "additional_insurance")
  end

  context "without additional insurance option" do
    subject(:commission) { described_class.new(10_000, 3, no_options) }
    # rental_price=10_000 (cents), duration=3 days

    it "splits the total_commission (30%) among insurance, assistance, drivy" do
      # total_commission = 30% of 10000 => 3000
      # insurance_fee = half => 1500
      # assistance_fee = 3 days => 3*100 => 300
      # drivy_fee = 3000 - 1500 - 300 => 1200
      expect(commission.insurance_fee).to eq(1500)
      expect(commission.assistance_fee).to eq(300)
      expect(commission.drivy_fee).to eq(1200)
    end
  end

  context "with additional insurance option" do
    subject(:commission) { described_class.new(10_000, 3, [insurance_option]) }

    it "adds the additional_insurance cost to the drivy fee" do
      # total_commission = 3000 again
      # insurance_fee=1500, assistance_fee=300 => leftover=1200
      # But we add additional insurance => + (1000 * 3) => 3000
      # final drivy_fee=1200 + 3000=4200
      expect(commission.insurance_fee).to eq(1500)
      expect(commission.assistance_fee).to eq(300)
      expect(commission.drivy_fee).to eq(4200)
    end
  end

  describe "#details" do
    it "returns a hash of the three fees" do
      commission = described_class.new(10_000, 2, no_options)
      expect(commission.details).to eq({
        insurance_fee: commission.insurance_fee,
        assistance_fee: commission.assistance_fee,
        drivy_fee: commission.drivy_fee
      })
    end
  end
end
