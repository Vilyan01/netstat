module Netstat
  class Socket
    attr_accessor :remote_address, :remote_address_quad, :remote_port,
                  :local_address, :local_address_quad, :local_port,
                  :state

    def initialize(attrs)
      attrs.each do |attr, value|
        send("#{attr}=", value)
      end
    end

    def self.parse_proc_line(line)
      splitline = line.split
      localaddr, localport = splitline[1].split(':')
      remoteaddr, remoteport = splitline[2].split(':')
      socket = {
        :remote_address      => remoteaddr,
        :remote_address_quad => [remoteaddr].pack("H*").unpack("C*").reverse.join("."),
        :remote_port         => remoteport.to_i(16),
        :local_address       => localaddr,
        :local_address_quad  => [localaddr].pack("H*").unpack("C*").reverse.join("."),
        :local_port          => localport.to_i(16),
        :state               => Netstat.tcp_states[splitline[3]]
      }
      new(socket)
    end
  end
end
