# Counter Strike Scoreboard
by Steven Occhipinti


## Intro

This is my first Sinatra app.
The goal of this app is to parse log data from a Counter Strike server and
present it as a live updating scoreboard.
This started out as a joke at a LAN party and I thought the idea was a good
simple app for me to give Sinatra a go.


## Dependencies

Run `bundle install` to fetch all the dependencies.


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

### scores.rb

`scores.rb` is a Sinatra app that reads the database and produces an
auto-updating scoreboard.
Currently the auto-update is accomplished with a `<meta>` tag, but will
eventually be AJAX based.

## Installation and Usage

To get up and running:
    bundle install
    bundle exec ruby scores.rb
When you browse to root URL of the app it will start the daemon process in the background.
You can check the status of the daemon with the `/daemon` path.
You should then be redirected to the `/scores` path where the scoreboard will
be displayed.
