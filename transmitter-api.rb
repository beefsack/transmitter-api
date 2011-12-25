require 'rubygems'
require 'sinatra'
require 'json'
require 'transmitter-data'
require 'haml'

disable :protection
set :haml, :format => :html5, :layout => true
@javascripts = []

get '/' do
  haml :index
end

get '/hunt' do
  @transmitter_data =
    TransmitterHunter::TransmitterData.new
  stations = @transmitter_data.find params[:lat].to_f, params[:long].to_f
  stations.sort! do |a, b|
    b[:strength] <=> a[:strength]
  end
  # Sort by strength
  # Break down by type
  types = {}
  stations.each do |station|
    types[station[:type]] = [] if types[station[:type]].nil?
    types[station[:type]] << station
  end
  haml :hunt, :locals => { :types => types }
end
