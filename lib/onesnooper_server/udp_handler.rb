# Handler for incoming UDP datagrams. Implements required methods
# for direct use with EventMachine listeners. This handler will not
# respond to incoming datagrams as its primary purpose is to record
# mirrored monitoring traffic.
class OnesnooperServer::UDPHandler < ::EventMachine::Connection

  DATAGRAM_PREFIX = 'MONITOR'

  # Receives data and triggers processing of the given
  # datagram. Main internal processing triggered from this
  # method should always happen asynchronously (i.e., using
  # EventMachine.defer or Deferrable classes).
  #
  # @param monitoring_datagram [String] incoming data payload
  def receive_data(monitoring_datagram)
    monitoring_datagram.chomp!
    source_port, source_ip = Socket.unpack_sockaddr_in(get_peername)
    unless monitoring_datagram.start_with?(DATAGRAM_PREFIX)
      ::OnesnooperServer::Log.warn "[#{self.class.name}] Discarding datagram from " \
                                   "#{source_ip}:#{source_port} (not #{DATAGRAM_PREFIX})"
      return
    end

    ::OnesnooperServer::Log.debug "[#{self.class.name}] Received #{monitoring_datagram.inspect} " \
                                  "from #{source_ip}:#{source_port}"
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
    def_deferr = ::EventMachine::DefaultDeferrable.new
    proc_callback = Proc.new { |response| ::OnesnooperServer::Log.debug(
      "[#{self.class.name}] Handled as: #{response}"
    ) }

    def_deferr.callback &proc_callback
    def_deferr.errback &proc_callback

    def_deferr
  end

end
