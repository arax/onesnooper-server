#
#
#
class OnesnooperServer::Datagrams::FailureDatagram < ::OnesnooperServer::Datagram
  #
  #
  #
  def run(deferred_callback)
    process(deferred_callback, "Failed monitoring result will not be recorded")
  end
end
