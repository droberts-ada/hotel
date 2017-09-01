require_relative 'spec_helper'

describe Hotel::RoomBlock do
  describe 'constructor' do
    before do
      @rooms = [1, 2, 3]
      @checkin = Date.new(2017, 1, 1)
      @checkout = @checkin + 3
      @rate = 50
    end
    it "takes rooms, dates and a rate" do
      block = Hotel::RoomBlock.new(@rooms, @checkin, @checkout, @rate)

      block.must_respond_to :rooms
      block.must_respond_to :checkin
      block.must_respond_to :checkout
      block.must_respond_to :rate
    end

    it "is an error to create with no rooms" do
      rooms = []

      proc {
        Hotel::RoomBlock.new(rooms, @checkin, @checkout, @rate)
      }.must_raise ArgumentError
    end
  end

  describe 'has_rooms?' do
    before do
      @rooms = [1, 2, 3]
      @checkin = Date.new(2017, 1, 1)
      @checkout = @checkin + 3
      @rate = 50
      @block = Hotel::RoomBlock.new(@rooms, @checkin, @checkout, @rate)
    end

    it "returns true if there are rooms" do
      3.times do
        @block.has_rooms?.must_equal true
        @block.reserve_room
      end
    end

    it "returns false if there are no rooms" do
      3.times do
        @block.reserve_room
      end
      @block.has_rooms?.must_equal false
    end
  end

  describe 'reserve_room' do
    before do
      @rooms = [1, 2, 3]
      @checkin = Date.new(2017, 1, 1)
      @checkout = @checkin + 3
      @rate = 50
      @block = Hotel::RoomBlock.new(@rooms, @checkin, @checkout, @rate)
    end

    it "returns an available room" do
      3.times do
        @rooms.must_include @block.reserve_room
      end
    end

    it "raises an error if no rooms are available" do
      3.times do
        @block.reserve_room
      end
      proc {
        @block.reserve_room
      }.must_raise Hotel::RoomBlock::NoRoomsError
    end
  end
end
