require_relative 'date_range'

module Hotel
  class Reservation < DateRange
    attr_reader :room, :rate

    def initialize(room, checkin, checkout, rate)
      @room = room
      @rate = rate
      super(checkin, checkout)
    end

    def price
      return nights * @rate
    end
  end
end
