require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'date'

require_relative '../lib/date_range'
require_relative '../lib/reservation'
require_relative '../lib/room_block'
require_relative '../lib/hotel'
