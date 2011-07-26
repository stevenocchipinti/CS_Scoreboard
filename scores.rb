# CS-ScoreBoard

# To run: ruby -rubygems scores.rb

require 'sinatra'
require 'sqlite3'

get '/' do
  redirect to('/daemon/init')
end


# The scoreboard
get '/scores' do
  # This query will fetch ALL statistics from the DB
  sql = "SELECT killer,
         COUNT(killer) as kills,
         SUM(headshot) as headshots
         FROM kills
         GROUP BY killer
         ORDER BY kills DESC"

  db = SQLite3::Database.new("db/cs.db")
  db.results_as_hash = true

  @stats = db.execute(sql)
  haml :scores
end


# The user can control the daemon from here
get '/daemon' do
  @result = `ruby daemon.rb status`
  haml :daemon
end

# When the app starts up '/' should redirect to this
get '/daemon/init' do
  @result = `ruby daemon.rb start`
  redirect to('/scores')
end

# This handles executing the daemons actions
get '/daemon/:action' do
  @result = `ruby daemon.rb #{params[:action]}`
  redirect to('/daemon')
end
