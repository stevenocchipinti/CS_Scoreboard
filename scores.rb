# CS-ScoreBoard

# To run: ruby -rubygems scores.rb 

require 'sinatra'
require 'sqlite3'

get '/' do
  redirect to('/scores')
end

get '/scores' do
  # This query will fetch ALL statistics from the DB
  sql = "select * from kills;"

  db = SQLite3::Database.new("cs.db")
  db.results_as_hash = true

  result = ""
  db.execute(sql) do |row|
    result << "#{row['killer']} killed #{row['killed']} with a #{row['weapon']}"
    result << row['headshot'] == 1 ? " IN THE HEAD!" : ""
  end

  return result

end

#get '/view/:stuff' do
  #haml :view
#end


