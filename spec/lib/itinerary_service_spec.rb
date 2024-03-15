# frozen_string_literal: true

RSpec.describe ItineraryService do
  describe '#initialize' do
    before do
      ENV['BASED'] = 'SQV'
      ARGV.replace ['input.txt']
    end

    it 'sets the based attribute' do
      expect(subject.based).to eq(ENV.fetch('BASED'))
    end

    it 'sets the path attribute' do
      expect(subject.path).to eq('input.txt')
    end
  end

  describe '#generate_itinerary' do
    context 'when arguments are missing' do
      before do
        ENV['BASED'] = nil
        ARGV.replace []
      end

      it 'prints an error message' do
        expect(subject).to receive(:print_error_message)
        subject.generate_itinerary
      end

      it 'does not call fetch_trips' do
        expect(subject).not_to receive(:fetch_trips)
        subject.generate_itinerary
      end
    end

    context 'when arguments are provided' do
      before do
        ENV['BASED'] = 'SQV'
        ARGV.replace ['input.txt']
      end

      it 'calls fetch_trips' do
        expect(subject).to receive(:fetch_trips)
        subject.generate_itinerary
      end
    end
  end
end
