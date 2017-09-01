require_relative 'spec_helper'

describe Hotel::Hotel do
  before do
    @hotel = Hotel::Hotel.new
  end
  describe "basics" do
    it "can be initialized" do
      @hotel.must_be_instance_of Hotel::Hotel
    end

    it "tracks reservations, rooms and room rate" do
      @hotel.must_respond_to :reservations
      @hotel.must_respond_to :rooms
      @hotel.must_respond_to :room_rate
    end
  end

  describe "reserve" do
    before do
      @checkin = Date.new(2017, 01, 01)
      @checkout = @checkin + 3
    end

    it "raises an error for an invalid room" do
      [105, -12, "foo"].each do |room|
        proc {
          @hotel.reserve(room, @checkin, @checkout)
        }.must_raise ArgumentError
      end
    end

    it "returns a reservation with dates set" do
      reservation = @hotel.reserve(12, @checkin, @checkout)

      reservation.must_be_kind_of Hotel::Reservation
      reservation.checkin.must_equal @checkin
      reservation.checkout.must_equal @checkout
    end

    it "adds the reservation to the list" do
      reservation = @hotel.reserve(12, @checkin, @checkout)

      @hotel.reservations.must_include reservation
    end
  end

  describe "list_reservations" do
    before do
      @date = Date.new(2017, 01, 01)
    end

    it "includes reservations for that date" do
      @hotel.reserve(12, @date-2, @date+2)
      @hotel.list_reservations(@date).length.must_equal 1
    end

    it "omits reservations not on that date" do
      @hotel.reserve(12, @date+2, @date+4)
      @hotel.list_reservations(@date).length.must_equal 0
    end

    it "returns an empty list if no reservations" do
      @hotel.reservations.length.must_equal 0
      @hotel.list_reservations(@date).length.must_equal 0
    end
  end

  describe "available_rooms" do
    before do
      @date = Date.new(2017, 01, 01)
    end

    it "returns all rooms if no reservations" do
      @hotel.available_rooms(@date, @date + 1).must_equal @hotel.rooms
    end

    it "returns only rooms not reserved on that date" do
      room = 12
      @hotel.reserve(room, @date - 2, @date + 2)
      @hotel.available_rooms(@date, @date + 1).must_equal (@hotel.rooms - [room])
    end

    it "ignores reservations for other dates" do
      room = 12
      @hotel.reserve(room, @date - 4, @date - 2)
      @hotel.available_rooms(@date, @date + 1).must_equal @hotel.rooms
    end
  end
end
