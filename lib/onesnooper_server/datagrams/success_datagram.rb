# Handles processing of datagrams with SUCESS monitoring
# messages. Performs 'save' operation on the backend.
class OnesnooperServer::Datagrams::SuccessDatagram < ::OnesnooperServer::Datagram

  def run(deferred_callback)
    ::EventMachine.defer { deferred_callback.succeed "Successful monitoring result was recorded" }
  end

end
