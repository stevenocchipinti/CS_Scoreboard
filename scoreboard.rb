# CS-ScoreBoard
#
# A Sinatra app to display the scoreboard!
#
# To run without Thin: ruby -rubygems scoreboard.rb
# To run with Thin:    bundle exec ruby scoreboard.rb

require 'sinatra'
require 'sqlite3'

# When browsing to the root url, start the daemon first
get '/' do
  redirect to('/daemon/init')
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
#  Daemon Control
# ------------------------------------------------------------------------------

daemon = "daemon.rb"

# The user can control the daemon from here
get '/daemon' do
  @result = `ruby #{daemon} status`
  @title = "Daemon Control"
  haml :daemon
end

# When the app starts up '/' should redirect to this
get '/daemon/init' do
  @result = `ruby #{daemon} start`
  redirect to('/scores')
end

# This handles executing the daemons actions
get '/daemon/:action' do
  @result = `ruby #{daemon} #{params[:action]}`
  redirect to('/daemon')
end

# ------------------------------------------------------------------------------
#  Other
# ------------------------------------------------------------------------------

# Use SCSS for the stylesheet
get '/style.css' do
  scss :style
end
