# frozen_string_literal: true

# SegmentParser is responsible for parsing segments from an input file.
class SegmentParser
  TRAVEL_METHODS = %w[flight train].freeze
  STAY_METHODS = %w[hotel].freeze

  SEGMENT_START = 'SEGMENT:'

  attr_reader :segments

  # Initializes a new SegmentParser instance and parses segments from the input file.
  #
  # @param [String] path The path to the input file.
  # @return [SegmentParser] A new instance of SegmentParser.
  def initialize(path:)
    @segments = parse_file(path)
  end

  private

  # Parses segments from the input file.
  #
  # @param [String] path The path to the input file.
  # @return [Array<TravelSegment, StaySegment>] An array of parsed segments.
  def parse_file(path)
    segments = []

    File.foreach(path) do |line|
      segments << parse_line(line) if line.start_with?(SEGMENT_START)
    end

    segments
  rescue Errno::ENOENT
    puts "Error: File not found at #{path}"
    []
  end

  # Parses a segment from a line of text.
  #
  # @param [String] line The line of text containing the segment information.
  # @return [TravelSegment, StaySegment] A parsed segment.
  def parse_line(line)
    line.gsub!(SEGMENT_START, '')
    segment_type = line.split(' ').first.downcase

    case segment_type
    when *TRAVEL_METHODS then TravelSegment.parse(line)
    when *STAY_METHODS then StaySegment.parse(line)
    end
  end
end
