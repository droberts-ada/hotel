require_relative 'reservation'

module Hotel
  class Hotel
    class AlreadyReservedError < StandardError ; end

    attr_reader :reservations, :rooms, :room_rate

    def initialize
      @rooms = (1..20).to_a
      @room_rate = 200
      @reservations = []
    end

    def reserve(room, checkin, checkout)
      # Check that the room exists
      unless @rooms.include? room
        raise ArgumentError.new("No such room #{room}")
      end

      # Check that the room is available
      unless available_rooms(checkin, checkout).include? room
        raise AlreadyReservedError.new("Room #{room} already has a reservation between #{checkin} and #{checkout}")
      end

      # Create the reservation
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

    def build_block(num_rooms, checkin, checkout, rate)
      return RoomBlock.new(@rooms.first(3), checkin, checkout, rate)
    end

    def reserve_from_block(block)
      room = block.reserve_room
      reservation = Reservation.new(room, block.checkin, block.checkout, block.rate)
    end
  end
end
