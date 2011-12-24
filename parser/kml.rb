require 'nokogiri'

module TransmitterHunter
  module Parser
    module Kml
      def self.parse(filename)
        puts "parsing #{filename}"
        return [{
          :lat => 5,
          :long => 5,
        }]
      end
    end
  end
end
