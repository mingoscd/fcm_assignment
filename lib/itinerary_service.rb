# frozen_string_literal: true

# ItineraryService is responsible for generating itineraries based on input files.
class ItineraryService
  attr_reader :based, :path

  def initialize
    @based = ENV.fetch('BASED', nil)
    @path = ARGV.first || nil
  end

  # Generates an itinerary based on the provided input file.
  #
  # @return [Array<Trip>] An array of Trip objects representing the generated itinerary.
  def generate_itinerary
    invalid_args? ? print_error_message : fetch_trips
  end

  private

  def invalid_args?
    path.nil? || !File.exist?(path) || based.nil?
  end

  def print_error_message
    puts 'Provide the path of the input file' if path.nil?
    puts 'Provide the BASED argument' if based.nil?
    puts 'The file provided does not exists' if path && !File.exist?(path)
    puts 'Usage example: BASED=SVQ bundle exec ruby main.rb input.txt'
  end

  def fetch_trips
    segments = SegmentParser.new(path:).segments
    SegmentGrouping.new(segments:, based:).trips
  end
end
