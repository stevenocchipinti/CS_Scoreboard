# CS-ScoreBoard

# To run: ruby -rubygems scores.rb 

require 'sinatra'
require 'sqlite3'

get '/' do
  redirect to('/scores')
end

get '/scores' do
  # This query will fetch ALL statistics from the DB
  sql = "SELECT killer,
         COUNT(killer) as kills,
         SUM(headshot) as headshots
         FROM kills
         GROUP BY killer
         ORDER BY kills DESC"

  db = SQLite3::Database.new("cs.db")
  db.results_as_hash = true

  @stats = db.execute(sql)

  haml :scores

end
