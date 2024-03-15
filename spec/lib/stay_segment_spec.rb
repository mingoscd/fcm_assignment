# frozen_string_literal: true

RSpec.describe StaySegment do
  let(:params) do
    {
      type: 'hotel',
      at: 'BCN',
      from_date: '2023-01-05',
      to_date: '2023-01-10'
    }
  end

  describe '#initialize' do
    it 'sets type, at, from_date, to_date' do
      stay_segment = StaySegment.new(params:)

      expect(stay_segment.type).to eq('hotel')
      expect(stay_segment.at).to eq('BCN')
      expect(stay_segment.from_date).to eq(Date.parse('2023-01-05'))
      expect(stay_segment.to_date).to eq(Date.parse('2023-01-10'))
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the StaySegment' do
      stay_segment = StaySegment.new(params:)
      expect(stay_segment.to_s).to eq("Hotel at BCN on 2023-01-05 to 2023-01-10\n")
    end
  end

  describe '.parse' do
    it 'creates a new StaySegment instance from a line of text' do
      line = 'Hotel BCN 2023-01-05 -> 2023-01-10'
      stay_segment = StaySegment.parse(line)

      expect(stay_segment.type).to eq('Hotel')
      expect(stay_segment.at).to eq('BCN')
      expect(stay_segment.from_date).to eq(Date.parse('2023-01-05'))
      expect(stay_segment.to_date).to eq(Date.parse('2023-01-10'))
    end
  end
end
