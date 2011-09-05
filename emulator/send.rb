require 'socket'

# Configuration
udphost = "srcds"
udpport = 1234
udpflags = 0
file = "test.log"

# Open the UDP socket so we can write to it
sock = UDPSocket.new

# Read the given file and send the contents via UDP
begin
    file = File.new(file, "r")
    while (line = file.gets)
      sock.send(line, udpflags, udphost, udpport)
      sleep 1
    end
    file.close
rescue => err
    puts "Error: #{err}"
    err
end
