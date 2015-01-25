# Request handler for validating and dispatching
# datagram processing on defined types of datagrams.
# Invalid or unknown datagrams will be processed by
# the `OnesnooperServer::Datagrams::InvalidDatagram`
# sub-handler.
class OnesnooperServer::RequestHandler

  # Validation constant for incoming datagrams
  MONITORING_DATA_REGEXP = /^MONITOR\s(?<result>[[:alpha:]]+)\s(?<host_id>\d+)\s(?<payload>\S+)$/

  # Registered allowed datagram processing classes & the default fallback
  DATAGRAMS = {
    "SUCCESS" => ::OnesnooperServer::Datagrams::SuccessDatagram,
    "FAILURE" => ::OnesnooperServer::Datagrams::FailureDatagram
  }
  DATAGRAMS.default = ::OnesnooperServer::Datagrams::InvalidDatagram

  # Static parsing method for identifying types of incoming datagrams
  # and choosing the right processing class for each datagram. Always
  # returns an instance responding to `run(callback)`.
  #
  # @param monitoring_datagram [Object] datagram payload for processing
  # @param source_ip [String] IP address of the client
  # @param source_port [String] port number of the client
  def self.parse(monitoring_datagram, source_ip, source_port)
    unless valid_data?(monitoring_datagram)
      ::OnesnooperServer::Log.fatal "[#{self.name}] Dropping invalid monitoring data #{monitoring_datagram.inspect}"
      return DATAGRAMS.default.new
    end

    unless valid_peer?(source_ip)
      ::OnesnooperServer::Log.fatal "[#{self.name}] Dropping monitoring data from #{source_ip}, not allowed!"
      return DATAGRAMS.default.new
    end

    match_data = monitoring_datagram.match(MONITORING_DATA_REGEXP)
    return DATAGRAMS.default.new unless match_data

    DATAGRAMS[match_data[:result]].new({
      host_id: match_data[:host_id],
      payload: match_data[:payload],
    })
  end

private

  # Identifies incoming datagrams as valid for further processing.
  # Datagrams must be non-nil and String-like.
  #
  # @param monitoring_datagram [Object] incoming datagram for validation
  # @return [Boolean] result
  def self.valid_data?(monitoring_datagram)
    monitoring_datagram && monitoring_datagram.kind_of?(String)
  end

  def self.valid_peer?(source_ip)
    ::OnesnooperServer::Settings.allowed_sources.include? source_ip
  end
end
