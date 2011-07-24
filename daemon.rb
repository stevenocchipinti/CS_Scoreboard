require 'daemon_spawn'
require 'sqlite3'

class MyServer < DaemonSpawn::Base

  def start(args)

    puts "Starting!"

    # This query will fetch ALL statistics from the DB
    sql = "select * from kills;"

    db = SQLite3::Database.new("cs.db")
    db.results_as_hash = true

    puts db

    db.prepare(sql) do |stmt|
      loop do
        stmt.execute do |result|
          while row = result.next do
            print "#{row['killer']} killed #{row['killed']} with a #{row['weapon']}"
            puts row['headshot'] == 1 ? " IN THE HEAD!" : ""
          end
        end
        sleep 10
      end
    end

    puts "Stopping!"

  end

  def stop
  end
end

MyServer.spawn!(:log_file => 'cs-scoreboard.log',
                :pid_file => 'cs-scoreboard.pid',
                :sync_log => true,
                :working_dir => File.dirname(__FILE__))
