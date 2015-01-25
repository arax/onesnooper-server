# Handles processing of datagrams with invalid
# messages. Doesn't perform any backend operations.
class OnesnooperServer::Datagrams::InvalidDatagram < ::OnesnooperServer::Datagram

  def run(deferred_callback)
    ::EventMachine.defer { deferred_callback.succeed "Invalid monitoring result will not be recorded" }
  end

end
