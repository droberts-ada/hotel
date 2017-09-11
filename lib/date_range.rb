module Hotel
  class DateRange
    class InvalidDateRange < StandardError ; end

    attr_reader :checkin, :checkout

    def initialize(checkin, checkout)
      unless checkout > checkin
        raise InvalidDateRange.new("Invalid dates #{checkin} to #{checkout}")
      end

      @checkin = checkin
      @checkout = checkout
    end

    def overlaps(other)
      return !(other.checkout <= @checkin || other.checkin >= @checkout)
    end

    def contains(date)
      return date >= @checkin && date < @checkout
    end

    def nights
      return @checkout - @checkin
    end
  end
end
