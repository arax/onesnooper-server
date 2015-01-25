#
#
#
class OnesnooperServer::RequestHandler

  #
  MONITORING_DATA_REGEXP = /^MONITOR\s(?<result>[[:alpha:]]+)\s(?<host_id>\d+)\s(?<payload>\S+)$/

  #
  DATAGRAMS = {
    "SUCCESS" => ::OnesnooperServer::Datagrams::SuccessDatagram,
    "FAILURE" => ::OnesnooperServer::Datagrams::FailureDatagram
  }
  DATAGRAMS.default = ::OnesnooperServer::Datagrams::InvalidDatagram

  #
  #
  #
  def self.parse(monitoring_datagram)
    unless valid_data?(monitoring_datagram)
      ::OnesnooperServer::Log.fatal "[#{self.name}] Dropping invalid monitoring data #{monitoring_datagram.inspect}"
      fail "Unexpected internal exception upon datagram arrival: Datagram format not valid!"
    end

    match_data = monitoring_datagram.match(MONITORING_DATA_REGEXP)
    if match_data
      DATAGRAMS[match_data[:result]].new({
        host_id: match_data[:host_id],
        payload: match_data[:payload],
      })
    else
      DATAGRAMS.default.new
    end
  end

private

  #
  #
  #
  def self.valid_data?(monitoring_datagram)
    monitoring_datagram && monitoring_datagram.kind_of?(String)
  end
end
