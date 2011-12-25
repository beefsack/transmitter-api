require 'rubygems'
require 'sinatra'
require 'json'
require 'transmitter-data'
require 'haml'

disable :protection
set :haml, :format => :html5
@javascripts = []

get '/' do
  haml :index, :locals => { :js => ['js/index.js'] },
    :layout => true
end

get '/hunt' do
  @transmitter_data =
    TransmitterHunter::TransmitterData.new
  stations = @transmitter_data.find params[:lat].to_f, params[:long].to_f
  puts YAML::dump(stations)
  haml :hunt
end
