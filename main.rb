# frozen_string_literal: true

# load dependencies
require 'date'
require 'zeitwerk'

# load classes in lib folder
loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.setup

puts ItineraryService.new.generate_itinerary
