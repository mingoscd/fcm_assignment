# frozen_string_literal: true

RSpec.describe Trip do
  let(:departure_segment1) { instance_double('TravelSegment', from: 'A', to: 'B', to_s: "Departure Segment 1\n") }
  let(:departure_segment2) { instance_double('TravelSegment', from: 'B', to: 'C', to_s: "Departure Segment 2\n") }
  let(:return_segment) { instance_double('TravelSegment', from: 'C', to: 'A', to_s: 'Return Segment') }
  let(:stay_segment) do
    instance_double('StaySegment', at: 'C', from_date: '2024-03-01', to_date: '2024-03-05', to_s: "Stay Segment\n")
  end

  describe '#initialize' do
    it 'sets origin, destination, departure_segments, return_segments, stay_segments' do
      trip = Trip.new(origin: 'Origin', destination: 'Destination',
                      departure_segments: [departure_segment1, departure_segment2],
                      return_segments: [return_segment], stay_segments: [stay_segment])

      expect(trip.origin).to eq('Origin')
      expect(trip.destination).to eq('Destination')
      expect(trip.departure_segments).to eq([departure_segment1, departure_segment2])
      expect(trip.return_segments).to eq([return_segment])
      expect(trip.stay_segments).to eq([stay_segment])
    end
  end

  describe '.from_segments' do
    it 'creates a new Trip instance from given segments' do
      trip = Trip.from_segments(departure_segments: [departure_segment1, departure_segment2],
                                return_segments: [return_segment], stay_segments: [stay_segment])

      expect(trip.origin).to eq('A')
      expect(trip.destination).to eq('C')
      expect(trip.departure_segments).to eq([departure_segment1, departure_segment2])
      expect(trip.return_segments).to eq([return_segment])
      expect(trip.stay_segments).to eq([stay_segment])
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the Trip' do
      trip = Trip.from_segments(departure_segments: [departure_segment1, departure_segment2],
                                return_segments: [return_segment], stay_segments: [stay_segment])

      expected_output = "TRIP to C\nDeparture Segment 1\nDeparture Segment 2\nStay Segment\nReturn Segment\n"
      expect(trip.to_s).to eq(expected_output)
    end
  end
end
