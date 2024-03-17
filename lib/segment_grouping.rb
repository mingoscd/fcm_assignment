# frozen_string_literal: true

# SegmentGrouping is responsible for grouping related segments into trips based on a given origin.
class SegmentGrouping
  attr_reader :based, :segments

  # Initializes a new SegmentGrouping instance.
  #
  # @param [String] based The origin location used for grouping trips.
  # @param [Array<TravelSegment, StaySegment>] segments An array of segments to be grouped into trips.
  # @return [SegmentGrouping] A new instance of SegmentGrouping.
  def initialize(based:, segments:)
    @based = based
    @segments = segments
  end

  # Groups segments into trips.
  #
  # @return [Array<Trip>] An array of Trip objects representing the grouped trips.
  def trips
    find_trips_by_segments
  end

  private

  # Finds trips based on segments.
  #
  # @return [Array<Trip>] An array of Trip objects representing the found trips.
  def find_trips_by_segments
    trip_start_segments, remaining_travel_segments = sorted_travel_segments.partition { |s| s.from == based }
    return [] if trip_start_segments.empty?

    trip_start_segments.map do |based_segment|
      group_trip_segments(based_segment, remaining_travel_segments)
    end
  end

  # Groups trip segments into a single trip.
  #
  # @param [TravelSegment] based_segment The initial travel segment for the trip.
  # @param [Array<TravelSegment>] remaining_travel_segments The remaining travel segments.
  # @return [Trip] A Trip object representing the grouped trip.
  def group_trip_segments(based_segment, remaining_segments)
    departure_segments = find_segment_path(based_segment, remaining_segments)
    return_init_segment = find_initial_return_segment(from: departure_segments.last.to,
                                                      remaining_segments: remaining_segments)
    return_segments = return_init_segment ? find_segment_path(return_init_segment, remaining_segments) : []
    stay_segments = select_stay_segments(departure_segments.last, return_segments.first)

    Trip.from_segments(
      departure_segments: departure_segments,
      stay_segments: stay_segments,
      return_segments: return_segments
    )
  end

  # Selects travel segments that are consecutive to the starting segment.
  #
  # @param [TravelSegment] start The starting travel segment.
  # @param [Array<TravelSegment>] segments The available travel segments.
  # @return [Array<TravelSegment>] An array of consecutive travel segments.
  def find_segment_path(start, segments)
    segment_path = [start]

    loop do
      new_segment = find_next_segment_in_path(segments, segment_path.last)
      new_segment ? segment_path << new_segment : break
    end

    segments.replace(segments - segment_path)

    segment_path
  end

  # Finds the initial segment that matches the specified origin.
  #
  # @param [String] from The origin to search for.
  # @param [Array<TravelSegment>] remaining_segments The travel segments search list.
  # @return [TravelSegment, nil] The initial travel segment matching the origin, or nil if not found.
  def find_initial_return_segment(from:, remaining_segments:)
    initial_segment = remaining_segments.find { |s| s.from == from }
    remaining_segments.delete(initial_segment) if initial_segment

    initial_segment
  end

  # Selects stay segments between the arrival and return travel segments.
  #
  # @param [TravelSegment] arrival_segment The arrival travel segment.
  # @param [TravelSegment, nil] return_segment The return travel segment, or nil if not available.
  # @return [Array<StaySegment>] An array of stay segments during the trip.
  def select_stay_segments(arrival_segment, return_segment)
    at = arrival_segment.to
    from_date = arrival_segment.date
    to_date = return_segment&.date

    stays = segments.select { |s| s.category == 'stay' && s.at == at && s.from_date >= from_date }
    stays = stays.select { |s| s.to_date <= to_date } if to_date

    stays
  end

  # Finds the next travel segment following the given segment.
  #
  # @param [Array<TravelSegment>] segments The available travel segments.
  # @param [TravelSegment] last_segment The last travel segment.
  # @return [TravelSegment, nil] The next travel segment, or nil if not found.
  def find_next_segment_in_path(segments, last_segment)
    segments.find do |next_segment|
      last_segment.to == next_segment.from && # chaining transfers prev destination with next trasfer origin
        last_segment.from != next_segment.to && # way back back is not valid as next segment
        last_segment.end_datetime < next_segment.start_datetime && # past segments are not valid as next segment
        last_segment.end_datetime.next_day >= next_segment.start_datetime # include transfers upto 24 hours
    end
  end

  def sorted_travel_segments
    segments.select { |s| s.category == 'travel' }.sort_by(&:start_datetime)
  end
end