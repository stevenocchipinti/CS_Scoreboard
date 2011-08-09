# Counter Strike Scoreboard
by Steven Occhipinti


## Intro

This is my first Sinatra app.
The goal of this app is to parse log data from a Counter Strike server and
present it as a live updating scoreboard.
This started out as a joke at a LAN party and I thought the idea was a good
simple app for me to give Sinatra a go.


## The basics

This app is broken into 3 parts:

### Counter Strike server

A Counter Strike server can be configured to send log data to a server
listening on a pre-defined UDP port.
To accomplish this, the following commands need to be executed in the server console:
    log on
    logaddress_add <server>:<port>
I would recommend putting these commands in the servers `server.cfg` file to be
automatically executed when the server is started.

### daemon.rb

`daemon.rb` listens on a UDP port for logging information.
When it receives data, it will run them through some known regular expressions.
If there is a match, that event is written to an SQLite3 database.

### scoreboard.rb

`scoreboard.rb` is a Sinatra app that reads the database and presents an
auto-updating scoreboard using AJAX.

## Installation and Usage

To get up and running:
<pre>
bundle install
bundle exec ruby scoreboard.rb
</pre>
When you browse to root URL of the app it will start the daemon process in the
background.
You can check the status of the daemon with the `/daemon` path.
You should then be redirected to the `/scores` path where the scoreboard will
be displayed.

## Adding CS-Scoreboard as a service on Linux

If you decide you want to run this permanently on your server (such as for a
dedicated gaming vps or something) there is a `wrapper.rb` script included that
handles the basic `start`, `stop` and `status` commands that you can add to
your system service configuration.
This will control the Sinatra app which provides a GUI for controlling the
background `daemon.rb` process.
