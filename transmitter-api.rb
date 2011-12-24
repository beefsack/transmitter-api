require 'rubygems'
require 'sinatra'
require 'json'
require 'transmitter-data'

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
  @transmitter_data.transmitters.each do |t|
    puts YAML::dump(t)
  end
  haml :hunt
end
