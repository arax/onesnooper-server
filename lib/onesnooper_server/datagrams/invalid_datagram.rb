#
#
#
class OnesnooperServer::Datagrams::InvalidDatagram < ::OnesnooperServer::Datagram
  #
  #
  #
  def run(defer)
    process(defer, 0, "Invalid monitoring result is specified")
  end
end
