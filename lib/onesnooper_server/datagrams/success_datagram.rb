#
#
#
class OnesnooperServer::Datagrams::SuccessDatagram < ::OnesnooperServer::Datagram
  #
  #
  #
  def run(defer)
    process(defer, 0, "Successful monitoring result is specified")
  end
end
