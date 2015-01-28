# Handles processing of datagrams with FAILED monitoring
# messages. Doesn't perform any backend operations.
class OnesnooperServer::Datagrams::FailureDatagram < ::OnesnooperServer::Datagram

  def run(deferred_callback)
    ::EventMachine.defer { deferred_callback.fail "Failed monitoring result will not be recorded" }
  end

end
