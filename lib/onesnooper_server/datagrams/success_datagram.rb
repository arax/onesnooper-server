#
#
#
class OnesnooperServer::Datagrams::SuccessDatagram < ::OnesnooperServer::Datagram
  #
  #
  #
  def run(deferred_callback)
    process(deferred_callback, "Successful monitoring result was recorded")
  end
end
