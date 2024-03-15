# frozen_string_literal: true

RSpec.describe SegmentGrouping do
  let(:based) { 'SVQ' }
  let(:segments) do
    [
      TravelSegment.new(params: { type: 'flight', from: 'SVQ', to: 'BCN', date: '2023-03-02', start_time: '06:40',
                                  end_time: '09:10' }),
      TravelSegment.new(params: { type: 'flight', from: 'BCN', to: 'SVQ', date: '2023-03-10', start_time: '10:00',
                                  end_time: '12:30' }),
      StaySegment.new(params: { type: 'hotel', at: 'BCN', from_date: '2023-01-05', to_date: '2023-01-10' })
    ]
  end

  describe '#initialize' do
    it 'sets based and segments' do
      grouping = SegmentGrouping.new(based:, segments:)
      expect(grouping.based).to eq('SVQ')
      expect(grouping.segments.size).to eq(3)
    end
  end

  describe '#trips' do
    context 'when there are segments for the based location' do
      it 'returns an array of Trip objects' do
        grouping = SegmentGrouping.new(based: 'SVQ', segments:)
        trips = grouping.trips
        expect(trips.size).to eq(1)
        expect(trips.first).to be_a(Trip)
        expect(trips.first.origin).to eq('SVQ')
        expect(trips.first.destination).to eq('BCN')
      end
    end

    context 'when there are no segments for the based location' do
      it 'returns nil' do
        grouping = SegmentGrouping.new(based: 'NYC', segments:)
        expect(grouping.trips).to be_empty
      end
    end
  end
end
