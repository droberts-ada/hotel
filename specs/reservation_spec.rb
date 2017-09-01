require_relative 'spec_helper'

describe Hotel::Reservation do
  before do
    @room = 12
    @checkin = Date.new(2017, 1, 1)
    @checkout = @checkin + 3
    @rate = 200
    @reservation = Hotel::Reservation.new(@room, @checkin, @checkout, @rate)
  end

  describe "constructor" do
    it "takes a room, checkin and checkout, and a rate" do
      @reservation.must_be_kind_of Hotel::Reservation
      @reservation.must_respond_to :room
      @reservation.must_respond_to :rate
    end

    it "is a kind of DateRange" do
      @reservation.must_be_kind_of Hotel::DateRange
    end
  end

  describe "price" do
    it "calculates the price" do
      expected_price = @rate * (@checkout - @checkin)
      @reservation.price.must_equal expected_price
    end
  end
end
