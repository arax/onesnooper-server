#
#
#
class OnesnooperServer::Datagrams::InvalidDatagram < ::OnesnooperServer::Datagram
  #
  #
  #
  def run(deferred_callback)
    process(deferred_callback, "Invalid monitoring result will not be recorded")
  end
end
