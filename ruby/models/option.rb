class Option
  TYPES = %w(gps baby_seat additional_insurance)
  attr_reader :id, :rental_id, :type

  def initialize(id:, rental_id:, type:)
    @id        = id
    @rental_id = rental_id
    @type      = type

    # Validate types
    raise "type should be one of #{TYPES.join(", ")}" unless TYPES.include?(type)
  end

  def price_per_day
    case type
    when "gps"
      500
    when "baby_seat"
      200
    when "additional_insurance"
      1000
    else
      0
    end
  end
end
