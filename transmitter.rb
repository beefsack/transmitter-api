require 'station'
require 'forwardable'
require 'geo-distance'

module TransmitterHunter
  class Transmitter
    extend Forwardable
    include Enumerable
    def_delegators :@stations, :each, :<<
    attr_accessor :name, :lat, :long, :type, :stations
    
    def initialize options = {}
      @stations = []
      options.each do |key, value|
        next if key == :stations
        instance_variable_set("@#{key}", value) unless value.nil?
      end
      if defined? options[:stations]
        options[:stations].each do |station|
          @stations << TransmitterHunter::Station.new(station)
        end
      end
    end

    def distance lat, long
      return GeoDistance.distance(self.lat, self.long, lat, long).meters
    end

    def stations_for_coordinates lat, long
      # Use approximation to filter down to transmitters within a smaller grid
      return [] if (self.lat - lat).abs > 2 or (self.long - long).abs > 4
      stations = []
      @stations.each do |station|
        stations << {
          :strength => rand(100),
          :station => station,
          :type => @type,
        }
      end
      return stations
    end
  end
end
