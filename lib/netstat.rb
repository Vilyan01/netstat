$LOAD_PATH.unshift(File.dirname(__FILE__))
require "netstat/version"
require 'netstat/socket'

module Netstat
  def self.procfile
    "/proc/net/tcp"
  end

  # States from http://snippets.dzone.com/posts/show/12653
  def self.tcp_states
    {
      '00' => 'UNKNOWN',  # Bad state ... Impossible to achieve ...
      'FF' => 'UNKNOWN',  # Bad state ... Impossible to achieve ...
      '01' => 'ESTABLISHED',
      '02' => 'SYN_SENT',
      '03' => 'SYN_RECV',
      '04' => 'FIN_WAIT1',
      '05' => 'FIN_WAIT2',
      '06' => 'TIME_WAIT',
      '07' => 'CLOSE',
      '08' => 'CLOSE_WAIT',
      '09' => 'LAST_ACK',
      '0A' => 'LISTEN',
      '0B' => 'CLOSING'
    }
  end

  def self.read_tcp
    sockets = []

    File.readlines(procfile)[1..-1].each do |line|
      sockets << Netstat::Socket.parse_proc_line(line)
    end

    Dir.glob("/proc/[1-9]*/fd/[1-9]*") do |dir|
      begin
        if socket = sockets.detect {|s| s.inode == File.stat(dir).ino}
          socket.pid = dir.split("/")[2]
          socket.programname = File.open("/proc/" + socket.pid + "/cmdline").
                                    read.split("/").last.split(".")[0]
        end
      rescue Errno::ENOENT
      end
    end

    sockets
  end
end
