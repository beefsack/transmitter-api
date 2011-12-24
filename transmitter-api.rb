require 'rubygems'
require 'sinatra'
require 'json'
require 'transmitter-data'

disable :protection
set :haml, :format => :html5, :layout => true

get '/' do
  haml :index
end

get '/hunt' do
  @transmitter_data =
    TransmitterHunter::TransmitterData.new
  @transmitter_data.transmitters.each do |t|
    puts YAML::dump(t)
  end
  haml :hunt
end
