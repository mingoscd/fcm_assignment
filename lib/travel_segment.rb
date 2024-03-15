# frozen_string_literal: true

# TravelSegment represents a segment of travel in a trip.
class TravelSegment
  FORMATTED_DATETIME_FORMAT = '%F %R'
  FORMATTED_TIME_FORMAT = '%R'

  attr_reader :type, :from, :to, :date, :start_datetime, :end_datetime

  # Initializes a new TravelSegment instance.
  #
  # @param [Hash] params The parameters to initialize the TravelSegment.
  # @option params [String] :type The type of travel (e.g., flight, train).
  # @option params [String] :from The departure location.
  # @option params [String] :to The destination location.
  # @option params [String] :date The date of travel in "YYYY-MM-DD" format.
  # @option params [String] :start_time The start time of travel in "HH:MM" format.
  # @option params [String] :end_time The end time of travel in "HH:MM" format.
  # @return [TravelSegment] A new instance of TravelSegment.
  def initialize(params:)
    @type = params[:type]
    @from = params[:from]
    @to = params[:to]
    @date = Date.parse(params[:date])
    @start_datetime = DateTime.parse("#{params[:date]} #{params[:start_time]}")
    @end_datetime = calculate_end_datetime(params)
  end

  def category = 'travel'

  # Returns a string representation of the TravelSegment.
  #
  # @return [String] A string representing the TravelSegment.
  def to_s
    "#{type.capitalize} from #{from} to #{to} at #{formated_travel_duration}\n"
  end

  # Parses a line of text and creates a new TravelSegment instance.
  #
  # @param [String] line The line of text to parse.
  # @return [TravelSegment] A new instance of TravelSegment parsed from the line.
  # @example
  #   TravelSegment.parse("Flight SVQ 2023-03-02 06:40 -> BCN 09:10")
  def self.parse(line)
    attr_values = line.split(' ').reject { |str| str == '->' }
    attr_keys = %i[type from date start_time to end_time]
    params = attr_keys.zip(attr_values).to_h

    new(params:)
  end

  private

  # If during the travel, the day changes the datetime date should change
  # If the travel spans more than 2 days, there's no way to know from the information that can be extracted
  # @example
  #   TravelSegment.parse("Flight SVQ 2023-03-02 20:40 -> BCN 01:10")
  def calculate_end_datetime(params)
    datetime = DateTime.parse("#{params[:date]} #{params[:end_time]}")
    datetime = datetime.next_day if datetime < start_datetime

    datetime
  end

  def formated_travel_duration
    end_format = start_datetime.to_date == end_datetime.to_date ? FORMATTED_TIME_FORMAT : FORMATTED_DATETIME_FORMAT

    start_duration = start_datetime.strftime(FORMATTED_DATETIME_FORMAT)
    end_duration = end_datetime.strftime(end_format)

    "#{start_duration} to #{end_duration}"
  end
end
