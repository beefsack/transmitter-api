require 'transmitter'
require 'parser/kml'
require 'yaml'
require 'dalli'
require 'forwardable'

module TransmitterHunter
  class TransmitterData
    extend Forwardable
    include Enumerable
    def_delegators :@transmitters, :each, :<<
    attr_reader :files, :transmitters

    def initialize
      load
    end

    def find lat, long
      stations = []
      each do |transmitter|
        transmitter.stations_for_coordinates(lat, long).each do |station|
          stations << station
        end
      end
      return stations
    end

    private
    def load
      # Check the cache
      dalli = Dalli::Client.new 'localhost:11211'
      raw_data = dalli.get 'transmitter-hunter-raw-data'
      if raw_data.nil?
        raw_data = []
        # Parse files yml
        data_dir = File.dirname(__FILE__) + '/data'
        @files = YAML::load(
          File.open(data_dir + '/files.yml'))
        # Load files
        @files['files'].each do |file|
          # Parse
          case file['filetype']
          when 'kml'
            parsed = TransmitterHunter::Parser::Kml::parse(
              data_dir + '/' + file['filename'])
          end
          parsed.each do |data|
            raw_data << data
          end
        end
        dalli.set 'transmitter-hunter-raw-data', raw_data
      end
      # Store locally
      @transmitters = []
      raw_data.each do |data|
        @transmitters << TransmitterHunter::Transmitter.new(data)
      end
    end
  end
end
