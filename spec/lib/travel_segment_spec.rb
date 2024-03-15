# frozen_string_literal: true

RSpec.describe TravelSegment do
  let(:params) do
    {
      type: 'flight',
      from: 'SVQ',
      to: 'BCN',
      date: '2023-03-02',
      start_time: '06:40',
      end_time: '09:10'
    }
  end

  describe '#initialize' do
    it 'sets type, from, to, date, start_datetime, end_datetime' do
      travel_segment = TravelSegment.new(params:)

      expect(travel_segment.type).to eq('flight')
      expect(travel_segment.from).to eq('SVQ')
      expect(travel_segment.to).to eq('BCN')
      expect(travel_segment.date).to eq(Date.parse('2023-03-02'))
      expect(travel_segment.start_datetime).to eq(DateTime.parse('2023-03-02 06:40'))
      expect(travel_segment.end_datetime).to eq(DateTime.parse('2023-03-02 09:10'))
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the TravelSegment' do
      travel_segment = TravelSegment.new(params:)
      expect(travel_segment.to_s).to eq("Flight from SVQ to BCN at 2023-03-02 06:40 to 09:10\n")
    end
  end

  describe '.parse' do
    it 'creates a new TravelSegment instance from a line of text' do
    end
  end
end
