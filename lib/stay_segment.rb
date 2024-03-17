# frozen_string_literal: true

# StaySegment represents a segment of stay in a trip.
class StaySegment
  attr_reader :type, :at, :from_date, :to_date

  # Initializes a new StaySegment instance.
  #
  # @param [Hash] params The parameters to initialize the StaySegment.
  # @option params [String] :type The type of stay (e.g., hotel, apartment).
  # @option params [String] :at The location of stay (e.g., city).
  # @option params [String] :from_date The start date of the stay in "YYYY-MM-DD" format.
  # @option params [String] :to_date The end date of the stay in "YYYY-MM-DD" format.
  # @return [StaySegment] A new instance of StaySegment.
  def initialize(params:)
    @type = params[:type]
    @at = params[:at]
    @from_date = Date.parse(params[:from_date])
    @to_date = Date.parse(params[:to_date])
  end

  def category = 'stay'

  # Returns a string representation of the StaySegment.
  #
  # @return [String] A string representing the StaySegment.
  def to_s
    "#{type.capitalize} at #{at} on #{from_date} to #{to_date}\n"
  end

  # Parses a line of text and creates a new StaySegment instance.
  #
  # @param [String] line The line of text to parse.
  # @return [StaySegment] A new instance of StaySegment parsed from the line.
  # @example
  #   StaySegment.parse("Hotel BCN 2023-01-05 -> 2023-01-10")
  def self.parse(line)
    attrs = line.split(' ').reject { |str| str == '->' }
    attr_keys = %i[type at from_date to_date]
    params = attr_keys.zip(attrs).to_h

    new(params: params)
  end
end
