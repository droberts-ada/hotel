require_relative 'reservation'

module Hotel
  class Hotel
    attr_reader :reservations, :rooms, :room_rate

    def initialize
      @rooms = (1..20).to_a
      @room_rate = 200
      @reservations = []
    end

    def reserve(room, checkin, checkout)
      unless @rooms.include? room
        raise ArgumentError.new("No such room #{room}")
      end

      reservation = Reservation.new(room, checkin, checkout, @room_rate)
      @reservations << reservation

      return reservation
    end

    def list_reservations(date)
      @reservations.select { |res| res.contains(date) }
    end

    def available_rooms(checkin, checkout)
      dates = DateRange.new(checkin, checkout)
      bookings = @reservations.select { |res| res.overlaps(dates) }
      reserved_rooms = bookings.map { |res| res.room }
      return @rooms - reserved_rooms
    end
  end
end
