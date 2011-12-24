module TransmitterHunter
  class Station
    attr_accessor :purpose, :callsign, :frequency, :power, :polarisation,
      :antenna_pattern, :mast_height

    def initialize options = {}
      options.each do |key, value|
        instance_variable_set("@#{key}", value) \
          unless value.nil?
      end
    end
  end
end
