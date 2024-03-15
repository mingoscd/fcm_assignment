# frozen_string_literal: true

# Trip represents a collection of related segments in an itinerary, consisting of departure, stay, and return segments.
class Trip
  attr_accessor :origin, :destination, :departure_segments, :return_segments, :stay_segments

  # Initializes a new Trip instance.
  #
  # @param [String] origin The origin location of the trip.
  # @param [String] destination The destination location of the trip.
  # @param [Array<TravelSegment>] departure_segments An array of departure travel segments.
  # @param [Array<StaySegment>] return_segments An array of return travel segments.
  # @param [Array<StaySegment>] stay_segments An array of stay segments during the trip.
  # @return [Trip] A new instance of Trip.
  def initialize(origin:, destination:, departure_segments:, return_segments:, stay_segments:)
    @origin = origin
    @destination = destination
    @departure_segments = departure_segments
    @return_segments = return_segments
    @stay_segments = stay_segments
  end

  # Returns a string representation of the Trip.
  #
  # @return [String] A string representing the Trip.
  def to_s
    "TRIP to #{destination}\n#{segments_to_formatted_s}\n"
  end

  # Creates a new Trip instance from given segments.
  #
  # @param [Array<TravelSegment>] departure_segments An array of departure travel segments.
  # @param [Array<TravelSegment>] return_segments An array of return travel segments.
  # @param [Array<StaySegment>] stay_segments An array of stay segments during the trip.
  # @return [Trip] A new instance of Trip created from the provided segments.
  def self.from_segments(departure_segments:, return_segments:, stay_segments:)
    new(
      origin: departure_segments.first.from,
      destination: departure_segments.last.to,
      departure_segments:,
      return_segments:,
      stay_segments:
    )
  end

  private

  def segments_to_formatted_s
    [departure_segments, stay_segments, return_segments].flatten.map(&:to_s).join
  end
end
