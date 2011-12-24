require 'nokogiri'

module TransmitterHunter
  module Parser
    module Kml
      def self.parse(filename)
        file = File.open filename
        doc = Nokogiri::XML file
        file.close
        items = []
        doc.search('Placemark').each do |place|
          item = {}
          item[:name] = place.search('name').first.content
          coords_str = place.search('Point coordinates').first.content
          coords = coords_str.split ','
          item[:lat] = coords[0].to_f
          item[:long] = coords[1].to_f
          items << item
        end
        puts YAML::dump(items)
        return items
      end
    end
  end
end
