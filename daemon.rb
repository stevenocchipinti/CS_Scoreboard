require 'daemon_spawn'
require 'sqlite3'
require 'socket'

class MyServer < DaemonSpawn::Base

  def start(args)
    # Process command-line args to get the logfile
    #abort "USAGE: daemon.rb LOGFILE" if args.empty?
    #@filename = args.first

    # Configuration
    port = 1234

    # Connect to the DB to request a hash of results later
    db = SQLite3::Database.new("cs.db")
    db.results_as_hash = true

    # Start listening for UDP data
    sock = UDPSocket.new
    sock.bind("0.0.0.0", port)

    time = Time.new.strftime "%d/%m/%Y@%H:%M:%S"
    puts "#{time}: Log parsing daemon listening on UDP #{port}"

    # Loop forever!
    loop do
      # Read 1024 bytes of UDP data from the socket
      data, addr = sock.recvfrom(1024)
      # Generate an appropriate SQL insert statement
      puts "Parsing {{ #{data} }}".gsub(/[\n\r]/,"")
      sql = log_line_to_sql_insert(data)
      puts "SQL     {{ #{sql} }}"
      # Write to the database
      db.execute(sql)
    end
  end

  def stop
    time = Time.new.strftime "%d/%m/%Y@%H:%M:%S"
    puts "#{time}: Log parsing daemon shutting down"
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
