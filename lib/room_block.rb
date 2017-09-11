module Hotel
  class RoomBlock < DateRange
    class NoRoomsError < StandardError ; end

    attr_reader :rooms, :block_size, :rate

    def initialize(rooms, checkin, checkout, rate)
      if rooms.empty?
        raise ArgumentError.new("Can't create a block without any rooms")
      end

      super(checkin, checkout)
      @rooms = rooms
      @available_rooms = rooms.dup
      @reserved_rooms = []
      @rate = rate
    end

    def has_rooms?
      return @available_rooms.length > 0
    end

    def reserve_room
      unless has_rooms?
        raise NoRoomsError.new("All rooms are reserved!")
      end

      room = @available_rooms.pop
      @reserved_rooms << room
      return room
    end
  end
end
