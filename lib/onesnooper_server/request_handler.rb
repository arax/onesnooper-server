#
#
#
class OnesnooperServer::RequestHandler
  DATAGRAMS = {
    "MONITOR SUCCESS" => ::OnesnooperServer::Datagrams::SuccessDatagram,
    "MONITOR FAILURE" => ::OnesnooperServer::Datagrams::FailureDatagram
  }
  DATAGRAMS.default = ::OnesnooperServer::Datagrams::InvalidDatagram

  #
  #
  #
  def self.parse(command)
    type, param = command.split(/^(MONITOR\s\w+)\s(\w+)$/).drop(1)
    DATAGRAMS[type].new(param)
  end
end
