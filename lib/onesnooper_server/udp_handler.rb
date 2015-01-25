#
#
#
class OnesnooperServer::UDPHandler < EM::Connection
  #
  #
  #
  def receive_data(command)
    command.chomp!
    ::OnesnooperServer::Log.debug("Received #{command}")
    ::OnesnooperServer::RequestHandler.parse(command).run(callback)
  end

private
  #
  #
  #
  def callback
    ::EM::DefaultDeferrable.new.callback do |response|
      send_data(response + "\n")
      ::OnesnooperServer::Log.debug(response)
    end
  end
end
