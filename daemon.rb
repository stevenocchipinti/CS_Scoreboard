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
    db = SQLite3::Database.new("db/cs.db")
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

      puts "Parsing {{ #{data} }}".gsub(/[\n\r]/,"")

      # Generate an appropriate SQL insert statement
      if sql = log_line_to_sql_insert(data)
        # If an SQL statement was generated, execute it!
        puts "SQL     {{ #{sql} }}"
        db.execute(sql)
      end

    end
  end

  def stop
    time = Time.new.strftime "%d/%m/%Y@%H:%M:%S"
    puts "#{time}: Log parsing daemon shutting down"
  end


  # Parse a line from the log to generate a SQL insert statement
  # This function contains the parsing patterns
  def log_line_to_sql_insert(line)

    # Define patterns for the various events
    patterns = {
      :kill => /(\d{2})\/(\d{2})\/(\d{4}) - (\d{2}):(\d{2}):(\d{2}): "(.*)<([^>])*><([^>]*)><([^>]*)>" killed "(.*)<([^>])*><([^>]*)><([^>]*)>" with "([^"]*)"(.*)/,
      :round_won => /\(CT "(\d*)"\) \(T "(\d*)"\)/ # TODO: FIX THIS PATTERN
    }
    # NOTE: There are multiple variants of the :round_won event, including
    #  "Target_Bombed"
    #  "CTs_Win"
    #  etc.

    # Test all patterns
    patterns.each do |event, pattern|
      line.scan(pattern) do |matches|
        puts "Event   {{ #{event} - #{matches} }}"
        case event
        when :kill
          #return "select * from kills limit 1"
          return "insert into kills (killer, killed, weapon, headshot) 
                  values('#{matches[6]}', '#{matches[10]}', '#{matches[14]}',
                  #{matches[15].empty? ? 0 : 1})"
        when :round_won
          # update the CT vs T counts (for this game/map?)
        when :suicide
          # decrement players kill count
        end
      end
    end

    return nil

  end

end

MyServer.spawn!(:log_file => 'cs-scoreboard.log',
                :pid_file => 'cs-scoreboard.pid',
                :sync_log => true,
                :working_dir => File.dirname(__FILE__))
