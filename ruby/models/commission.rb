class Commission
  attr_reader :insurance_fee, :assistance_fee, :drivy_fee

  def initialize(rental_price, duration)
    total_commission = (rental_price * 0.3).to_i
    @insurance_fee   = total_commission / 2
    @assistance_fee  = duration * 100
    @drivy_fee       = total_commission - @insurance_fee - @assistance_fee
  end

  def total
    insurance_fee + assistance_fee + drivy_fee
  end

	def details
		{
			insurance_fee: insurance_fee,
			assistance_fee: assistance_fee,
			drivy_fee: drivy_fee
		}
	end
end