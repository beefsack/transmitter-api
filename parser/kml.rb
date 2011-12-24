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
          item[:stations] = []
          description_text = place.search('description').first.content
          description = Nokogiri::HTML description_text
          header_map = []
          description.search('tr').each do |desc_row|
            cells = desc_row.search('td')
            if cells.count == 0
              # Header row, generate map
              header_cells = desc_row.search('th')
              next unless header_cells.count > 0
              header_map = []
              header_cells.each do |header_cell|
                case header_cell.content.downcase
                when 'purpose'
                  header_map << :purpose
                when 'callsign'
                  header_map << :callsign
                when 'frequency'
                  header_map << :frequency
                when 'power'
                  header_map << :power
                when 'polarisation'
                  header_map << :polarisation
                when /pattern$/
                  header_map << :antenna_pattern
                when /height$/
                  header_map << :mast_height
                end
              end
            else
              # Station row
              station = {}
              header_map.each_index do |index|
                station[header_map[index]] = cells[index].content
              end
              item[:stations] << station
            end
          end
          items << item
        end
        return items
      end
    end
  end
end
