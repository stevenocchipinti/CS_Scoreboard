require 'daemon_spawn'
require 'sqlite3'

class MyServer < DaemonSpawn::Base

  def start(args)
    # Process command-line args to get the logfile
    abort "USAGE: daemon.rb LOGFILE" if args.empty?
    @filename = args.first

    file = File.open(@filename)
    puts "Log parsing daemon (#{self.index}) started @ #{Time.new}"

    # Loop forever!
    loop do
      # Connect to the DB to get a hash of results
      db = SQLite3::Database.new("cs.db")
      db.results_as_hash = true

      # Process the new lines
      while (line = file.gets)
        # Generate an appropriate SQL insert statement
        sql = log_line_to_sql_insert(line)
        # Debug
        puts "Parsing {{ #{line} }}".gsub(/[\n\r]/,"")
        puts "SQL     {{ #{sql} }}"
        # Write to the database
        db.execute(sql)
      end
      sleep 10
    end
  end

  def stop
  end

  def log_line_to_sql_insert(line)
    # TODO: parse with regex and return an insert statement
    return "insert into kills (killer, killed, weapon, headshot) values('0x', 'r0cch1', 'M4A1', 1)"
  end

end

MyServer.spawn!(:log_file => 'cs-scoreboard.log',
                :pid_file => 'cs-scoreboard.pid',
                :sync_log => true,
                :working_dir => File.dirname(__FILE__))
