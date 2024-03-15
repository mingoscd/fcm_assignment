# frozen_string_literal: true

RSpec.describe SegmentParser do
  let(:file_content) do
    <<~FILE_CONTENT.lstrip
      RESERVATION
      SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10

      RESERVATION
      SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10

      RESERVATION
      SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
      SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50

      RESERVATION
      SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
      SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30

      RESERVATION
      SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17

      RESERVATION
      SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45
    FILE_CONTENT
  end

  let(:input_path) { 'input.txt' }

  before do
    allow(File).to receive(:open).with(input_path).and_return(file_content)
  end

  describe '#initialize' do
    it 'parses segments from the input file' do
      expect(TravelSegment).to receive(:parse).exactly(6).times
      expect(StaySegment).to receive(:parse).exactly(2).times

      segment_parser = SegmentParser.new(path: input_path)
      expect(segment_parser.segments.size).to eq(8)
    end
  end
end
