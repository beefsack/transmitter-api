require 'transmitter'
require 'parser/kml'
require 'yaml'

module TransmitterHunter
  class TransmitterData
    attr_reader :files, :transmitters

    def initialize
      load
    end

    private
    def load
      # Parse files yml
      @files = YAML::load(
        File.open(File.dirname(__FILE__) + '/data/files.yml'))
      # Load files
      @transmitters = []
      @files['files'].each do |file|
        # Parse
        case file['filetype']
        when 'kml'
          parsed = TransmitterHunter::Parser::Kml::parse(
            file['filename'])
        end
        # Store locally
        parsed.each do |data|
          @transmitters << TransmitterHunter::Transmitter.new(data)
        end
      end
    end
  end
end
