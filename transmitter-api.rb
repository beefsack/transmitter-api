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
  haml :hunt, :locals => { :stations => stations }
end
