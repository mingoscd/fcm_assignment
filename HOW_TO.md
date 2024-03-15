## SOLUTION DESCRIPTION

The project is centered around the `ItineraryService` class, which orchestrates the generation of itineraries based on input file.
This class coordinates with several subdependencies to achieve its goal:

- `SegmentParser`: This class is responsible for parsing segments from an input file. It reads the input file, identifies segments, and creates corresponding objects representing these segments. These objects are then passed to the `SegmentGrouping` class for further processing.

- `SegmentGrouping`: This class handles the grouping of related segments into trips. It receives segments from the `SegmentParser` and organizes them into trips based on a specified origin location. It utilizes logic to group consecutive travel segments into trips, considering factors such as departure, stay, and return segments.

- `Trip`, `StaySegment` and `TravelSegment`: These classes serve as abstractions representing different types of segments within a trip itinerary. `Trip` represents a collection of related segments, while `StaySegment` and `TravelSegment` represent specific types of segments, such as stays at accommodations or travel via various methods (e.g., flight, train).

Additionally, the project supports extension of segment types beyond the initial examples (flight, train, hotel). This extensibility is facilitated by the `TRAVEL_METHODS` and `STAY_METHODS` constants within the `SegmentParser` class. Adding new segment types involves simply including their respective types in these constants, allowing for easy integration of additional segment types into the itinerary generation process.

The parsing method employed follows a structured approach tailored to the fixed format of segment structures. By breaking down the segment structure into simple parts, the parsing method efficiently feeds data to their respective classes. Notably, there's no imposition on the use of three-letter capital words for origins and destinations, offering flexibility in the parse process.

## TESTS

All classes are thoroughly tested using the `rspec` framework/library. You can execute the full test suite using the command `rspec`. Ensure you have installed the library dependencies before running the tests by using the command `bundle`.

## OTHER

The code was formatted using the IDE `rubocop` extension with a syntax target of 3.1+. So, do not mind the syntax [omitting the named argument values](https://rubyreferences.github.io/rubychanges//3.1.html#values-in-hash-literals-and-keyword-arguments-can-be-omitted). Resulting in, `new(params:)` is the same as `new(params: params)` when the variable `params` is defined. So if you want to run the program using a ruby version previous to 3.1 might be a problem 😥. I added branch `hash_style_enforced_shorthand_syntax` to avoid this problem just in case.