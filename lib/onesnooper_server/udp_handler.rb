#
#
#
class OnesnooperServer::UDPHandler < ::EventMachine::Connection

  #
  #
  #
  def receive_data(monitoring_datagram)
    monitoring_datagram.chomp!
    ::OnesnooperServer::Log.debug "[#{self.class.name}] Received #{monitoring_datagram.inspect}"
    ::OnesnooperServer::RequestHandler.parse(monitoring_datagram).run(callback)
  end

private

  #
  #
  #
  def callback
    ::EventMachine::DefaultDeferrable.new.callback { |response| ::OnesnooperServer::Log.debug("[#{self.class.name}] Responding with: #{response}") }
  end

end
