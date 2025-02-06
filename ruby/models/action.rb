class Action
	TYPES = %w[debit credit].freeze
	WHOS = %w[driver owner insurance assistance drivy].freeze
  attr_reader :who, :type, :amount

  def initialize(who:, type: "credit", amount:)
		@who = who
		@type = type
		@amount = amount

		# Validate types
		raise "type should be one of #{TYPES.join(", ")}" unless TYPES.include?(type)

		# Validate whos
		raise "who should be one of #{WHOS.join(", ")}" unless WHOS.include?(who)
  end

	def to_h
		{
			who: @who,
			type: @type,
			amount: @amount
		}
	end
end
