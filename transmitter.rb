require 'station'
require 'forwardable'

module TransmitterHunter
  class Transmitter
    extend Forwardable
    include Enumerable
    def_delegators :@stations, :each, :<<
    attr_accessor :name, :lat, :long
    @stations = []

    def initialize options = {}
      options.each do |key, value|
        instance_variable_set("@#{key}", value) \
          unless value.nil?
      end
    end
  end
end
