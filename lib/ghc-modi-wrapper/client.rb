#!/usr/bin/env ruby
require "socket"
require "fileutils"

PID_FILE = ".ghc-modi-wrapper.pid"
SOCKET_FILE = ".ghc-modi-wrapper.sock"

def cleanup_temp
  FileUtils.rm_f(PID_FILE)
  FileUtils.rm_f(SOCKET_FILE)
end

def running_pid
  if File.exists?(PID_FILE)
    File.read(PID_FILE).strip.to_i
  else
    # TODO - do this in a better way
    -1
  end
end

def running?
  Process.getpgid(running_pid)
  true
rescue Errno::ESRCH
  false
end

def kill_server
  if File.exists?(PID_FILE)
    begin
      Process.kill("HUP", running_pid)
      puts "Server stopped."

    # This can only happen if the pid file was present but the server
    # wasn't running.
    rescue Errno::ESRCH
      puts "Process wasn't running, but pid file was present. Removing pid file."
      FileUtils.rm(PID_FILE)
    end
  else
    puts "Server isn't running."
  end
end

def ensure_server_running
  if running?
    unless File.exists?(SOCKET_FILE)
      puts "Server is broken, killing the server. Please retry your command"
      `pkill #{running_pid}`
      cleanup_temp
      exit 1
    end
  else
    Process.spawn("ruby internet.rb")
    sleep 1
  end
end

def send_command(command)
  connection = UNIXSocket.new(SOCKET_FILE)
  connection.puts command

  consuming = true
  consumed = []

  count = 0
  while consuming
    line = connection.gets

    if (count > 20) || (line && line.strip == "OK") || line[0..1] == "NG"
      consuming = false
    else
      consumed << line
    end

    count += 1
  end

  connection.close
  consumed.join("")
end

command = ARGV[0]

if command == "kill"
  kill_server
else
  case command
  when "check"
    ensure_server_running
    File.write("/tmp/somelog.txt", ARGV.join(" "))
    puts send_command("check #{ARGV[1]}")
    # puts `ghc-mod #{ARGV.join(" " )}`
  when "version"
    puts `ghc-mod version`
  else
    puts `ghc-mod #{ARGV.join(" ")}`
  end
end