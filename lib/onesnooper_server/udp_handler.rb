# Handler for incoming UDP datagrams. Implements required methods
# for direct use with EventMachine listeners. This handler will not
# respond to incoming datagrams as its primary purpose is to record
# mirrored monitoring traffic.
class OnesnooperServer::UDPHandler < ::EventMachine::Connection

  # Receives data and triggers processing of the given
  # datagram. Main internal processing triggered from this
  # method should always happen asynchronously (i.e., using
  # EventMachine.defer or Deferrable classes).
  #
  # @param monitoring_datagram [String] incoming data payload
  def receive_data(monitoring_datagram)
    monitoring_datagram.chomp!
    source_port, source_ip = Socket.unpack_sockaddr_in(get_peername)

    ::OnesnooperServer::Log.debug "[#{self.class.name}] Received #{monitoring_datagram.inspect} from #{source_ip}:#{source_port}"
    ::OnesnooperServer::RequestHandler.parse(
      monitoring_datagram,
      source_ip,
      source_port
    ).run(callback)
  end

private

  # Callable processing callback. As this implementation does
  # not send responses to incoming datagrams, this methods is
  # for logging and debugging purposes only.
  def callback
    ::EventMachine::DefaultDeferrable.new.callback { |response| ::OnesnooperServer::Log.debug(
      "[#{self.class.name}] Responding with: #{response}"
    ) }
  end

end
