# CS-ScoreBoard Wrapper
#
# A simple wrapper that can be used to start and stop the Sinatra app.
# This is useful to add to the operating systems service management as the
# standard 'start', 'stop' and 'status' commands will work as expected.
#
# For example, in Ubuntu:
#   sudo update-rc.d <script> defaults
#
# Note, it may be worth writing a bash wrapper to execute this as a non-root
# user. This can be done like this:
#   sudo -u someuser ruby wrapper.rb $1
#   exit $?
#

require 'daemon_spawn'

class CSScoreboard < DaemonSpawn::Base

  def start(args)
    # Start the Sinatra app
    exec "foreman start"
  end

  def stop
  end

end

CSScoreboard.spawn!(:log_file => 'cs-scoreboard.log',
                    :pid_file => 'cs-scoreboard.pid',
                    :sync_log => true,
                    :working_dir => File.dirname(__FILE__))
