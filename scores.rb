require 'sinatra'

get '/' do
  'Put this in your pipe and smoke it!'
end

get '/view/:stuff' do
  haml :view
end
