#!/usr/bin/ruby
require 'socket'
require 'optparse'

params = ARGV.getopts("lzah")
splitter = case
when params["l"]
  /\n+/
when params["z"]
  "\000"
else
  /\s+/
end

usearg = params["a"]

q = []

if params["h"]
  print <<EOF
qargs-q.rb [-lza] <queue-name> [<item>...]

  -l
        Read from STDIN and split newline instead of whitespace.

  -z
        Read from STDIN and split null character instead of whitespace.

  -a
        Use Arguments.
EOF
end

QNAME = ARGV.shift
unless QNAME
  abort "Queue name is not given.
qargs-q.rb [-lza] <queue-name> [<item>...]"
end

QUEUE = if usearg
  ARGV.dup
else
  STDIN.read.split(splitter)
end

if QNAME.include?("/") || QNAME.include?("\n")
  abort "Invalid character in queue name."
end

server = UNIXServer.new("/run/user/#{Process.euid}/qargs-#{QNAME}.sock")
begin
  while s = server.accept
    begin
      s.print QUEUE.shift
      s.close
    rescue
      nil
    end
    break if QUEUE.empty?
  end
ensure
  File.unlink("/run/user/#{Process.euid}/qargs-#{QNAME}.sock") rescue nil
end