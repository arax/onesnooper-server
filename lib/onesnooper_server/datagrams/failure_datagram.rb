#
#
#
class OnesnooperServer::Datagrams::FailureDatagram < ::OnesnooperServer::Datagram
  #
  #
  #
  def run(defer)
    process(defer, 0, "Failed monitoring result is specified")
  end
end
