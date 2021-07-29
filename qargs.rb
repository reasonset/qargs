#!/usr/bin/ruby
require 'socket'

QNAME = ARGV.shift
CMD = ARGV.shift

unless QNAME && CMD
  abort "Queue name or command is not given.
qargs.rb <queue-name> <command> [<command-arg>...]"
end

begin
  while s = UNIXSocket.open("/run/user/#{Process.euid}/qargs-#{QNAME}.sock")
    arg = s.read
    break unless arg
    break if arg.empty?
    system(CMD, *ARGV, arg)
  end
rescue
  exit
end
