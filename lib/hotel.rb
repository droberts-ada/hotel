require_relative 'reservation'

module Hotel
  class Hotel
    class AlreadyReservedError < StandardError ; end

    attr_reader :reservations, :rooms, :room_rate

    def initialize
      @rooms = (1..20).to_a
      @room_rate = 200
      @reservations = []
      @blocks = []
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
      # Strategy: Start with a list of all rooms, remove
      # rooms that are blocked or reserved for that date
      dates = DateRange.new(checkin, checkout)
      available_rooms = @rooms

      # Select blocks that overlap this date
      overlap_blocks = @blocks.select do |block|
        block.overlaps(dates)
      end

      # Put together a big list of all the rooms for those blocks
      blocked_rooms = overlap_blocks.reduce([]) do |memo, block|
        memo += block.rooms
      end
      available_rooms -= blocked_rooms

      # Get a list of all rooms reserved for that date
      overlap_reservations = @reservations.select do |res|
        res.overlaps(dates)
      end
      reserved_rooms = overlap_reservations.map do |res|
        res.room
      end

      available_rooms -= reserved_rooms

      return available_rooms
    end

    def build_block(num_rooms, checkin, checkout, rate)
      rooms = available_rooms(checkin, checkout)
      if rooms.length < num_rooms
        raise AlreadyReservedError("Not enough rooms available")
      end

      block = RoomBlock.new(rooms.first(num_rooms), checkin, checkout, rate)
      @blocks << block
      return block
    end

    def reserve_from_block(block)
      # RoomBlock#reserve_room will raise an error if there
      # aren't enough rooms, so we don't need to here
      room = block.reserve_room
      reservation = Reservation.new(room, block.checkin, block.checkout, block.rate)
    end
  end
end
