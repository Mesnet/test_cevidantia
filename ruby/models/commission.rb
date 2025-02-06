class Commission
  attr_reader :insurance_fee, :assistance_fee, :drivy_fee


  def initialize(rental_price, duration, options)
    total_commission = (rental_price * 0.3).to_i
    @insurance_fee   = total_commission / 2
    @assistance_fee  = duration * 100

    # Find the additional insurance option and calc price
    insurance_option = options.detect { |o| o.type == "additional_insurance" }
    insurance_option_fee = insurance_option ? insurance_option.price_per_day * duration : 0

    @drivy_fee       = total_commission - @insurance_fee - @assistance_fee + insurance_option_fee
  end

	def details
		{
			insurance_fee: insurance_fee,
			assistance_fee: assistance_fee,
			drivy_fee: drivy_fee
		}
	end
end
