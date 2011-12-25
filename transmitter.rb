require 'station'
require 'forwardable'

module TransmitterHunter
  class Transmitter
    extend Forwardable
    include Enumerable
    def_delegators :@stations, :each, :<<
    attr_accessor :name, :lat, :long, :stations

    def initialize options = {}
      @stations = []
      options.each do |key, value|
        next if key == :stations
        instance_variable_set("@#{key}", value) \
          unless value.nil?
      end
      if defined? options[:stations]
        options[:stations].each do |station|
          @stations << TransmitterHunter::Station.new(station)
        end
      end
    end
  end
end
