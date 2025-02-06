class Action
  attr_reader :who, :type, :amount

  def initialize(who:, type: "credit", amount:)
		@who = who
		@type = type
		@amount = amount
  end

	def to_h
		{
			who: @who,
			type: @type,
			amount: @amount
		}
	end
end
