# Counter Strike Scoreboard
by Steven Occhipinti


## Intro

This is my first Sinatra app.
The goal of this app is to parse log data from a Counter Strike server and
present it as a live updating scoreboard.
This started out as a joke at a LAN party and I thought the idea was a good
simple app for me to give Sinatra a go.


## Dependencies

The following gems are required to use this app:

* sinatra
* daemon-spawn
* sqlite3


## The basics

This app is broken into 2 parts:

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

Ensure the required gems are installed and use this to start Sinatra:
    ruby -rubygems scores.rb
When you browse to the app for the first time, it should start the daemon
process in the background.
You can check the status of the daemon with the `/daemon` path.
You should then be redirected to the `/scores` path where the scoreboard will
be visible.
