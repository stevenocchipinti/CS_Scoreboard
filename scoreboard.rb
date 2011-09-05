# CS-ScoreBoard
#
# A Sinatra app to display the scoreboard!
#
# To run without Thin: ruby -rubygems scoreboard.rb
# To run with Thin:    bundle exec ruby scoreboard.rb

require 'sinatra'
require 'sqlite3'


# ------------------------------------------------------------------------------
#  Root URL
# ------------------------------------------------------------------------------

# When browsing to the root url, go straight to the scoreboard
get '/' do
  redirect to('/scores')
end


# ------------------------------------------------------------------------------
#  The Scoreboard
# ------------------------------------------------------------------------------

get '/scores' do
  # This query will fetch ALL statistics from the DB
  sql = "SELECT killer,
         COUNT(killer) as kills,
         SUM(headshot) as headshots
         FROM kills
         GROUP BY killer
         ORDER BY kills DESC"

  # Connect to the database and execute the query
  db = SQLite3::Database.new("db/cs.db")
  db.results_as_hash = true
  @stats = db.execute(sql)

  # Use jquery to auto-update
  # To stop the auto-update, use: clearInterval(autoUpdateId)
  @jquery = "var autoUpdateId = setInterval(function() {
               $('#body').load('/scores');
             }, 1000);"

  @title = "Leader Board"
  # If AJAX request, dont render the layout
  haml :scores, :layout => (request.xhr? ? false : :layout)
end


# ------------------------------------------------------------------------------
#  Other
# ------------------------------------------------------------------------------

# Use SCSS for the stylesheet
get '/style.css' do
  scss :style
end
