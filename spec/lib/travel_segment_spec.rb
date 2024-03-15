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

    context 'when segment duration spans multiple days' do
      it 'returns the end_datetime as with full format' do
        travel_segment = TravelSegment.new(params: params.merge(end_time: '01:10'))
        expect(travel_segment.to_s).to eq("Flight from SVQ to BCN at 2023-03-02 06:40 to 2023-03-03 01:10\n")
      end
    end
  end

  describe '.parse' do
    it 'creates a new TravelSegment instance from a line of text' do
      line = 'Flight SVQ 2023-03-02 06:40 -> BCN 09:10'
      travel_segment = TravelSegment.parse(line)

      expect(travel_segment.type).to eq('Flight')
      expect(travel_segment.from).to eq('SVQ')
      expect(travel_segment.to).to eq('BCN')
      expect(travel_segment.date).to eq(Date.parse('2023-03-02'))
      expect(travel_segment.start_datetime).to eq(DateTime.parse('2023-03-02 06:40'))
      expect(travel_segment.end_datetime).to eq(DateTime.parse('2023-03-02 09:10'))
    end
  end
end
