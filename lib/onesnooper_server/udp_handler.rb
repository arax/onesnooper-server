# Handler for incoming UDP datagrams. Implements required methods
# for direct use with EventMachine listeners. This handler will not
# respond to incoming datagrams as its primary purpose is to record
# mirrored monitoring traffic.
class OnesnooperServer::UDPHandler < ::EventMachine::Connection

  # Allowed datagram prefix
  DATAGRAM_PREFIX = 'MONITOR'

  # Registered allowed stores for monitoring data
  STORES = {
    "mongodb" => ::OnesnooperServer::Stores::MongodbStore,
    "mysql"   => ::OnesnooperServer::Stores::MysqlStore,
    "sqlite"  => ::OnesnooperServer::Stores::SqliteStore,
  }
  STORES.default = ::OnesnooperServer::Stores::InvalidStore

  def initialize(*args)
    super
    @store_instances = store_instances(
      ::OnesnooperServer::Settings.store,
      ::OnesnooperServer::Settings.stores
    )
  end

  # Receives data and triggers processing of the given
  # datagram. Main internal processing triggered from this
  # method should always happen asynchronously (i.e., using
  # EventMachine.defer or Deferrable classes).
  #
  # @param monitoring_datagram [String] incoming data payload
  def receive_data(monitoring_datagram)
    monitoring_datagram.chomp!
    source_port, source_ip = Socket.unpack_sockaddr_in(get_peername)
    unless monitoring_datagram.start_with?(DATAGRAM_PREFIX)
      ::OnesnooperServer::Log.warn "[#{self.class.name}] Discarding datagram from " \
                                   "#{source_ip}:#{source_port} (not #{DATAGRAM_PREFIX})"
      return
    end

    ::OnesnooperServer::Log.debug "[#{self.class.name}] Received #{monitoring_datagram.inspect} " \
                                  "from #{source_ip}:#{source_port}"
    ::OnesnooperServer::RequestHandler.parse(
      monitoring_datagram,
      source_ip,
      source_port,
      @store_instances
    ).run(callback)
  end

private

  # Callable processing callback. As this implementation does
  # not send responses to incoming datagrams, this methods is
  # for logging and debugging purposes only.
  def callback
    def_deferr = ::EventMachine::DefaultDeferrable.new
    proc_callback = Proc.new { |response| ::OnesnooperServer::Log.debug(
      "[#{self.class.name}] Handled as: #{response}"
    ) }

    def_deferr.callback &proc_callback
    def_deferr.errback &proc_callback

    def_deferr
  end

  # Retrieves a list of instances for allowed store backends.
  #
  # @param enabled_stores [Hash] hash-like list of enabled stores
  # @param store_configs [Hash] hash-like set of store configurations
  # @return [Array] list of store instances
  def store_instances(enabled_stores, store_configs)
    fail "No stores have been enabled, see configuration file" if enabled_stores.blank?
    fail "No store configuration present, see configuration file" if store_configs.blank?

    enabled_stores.collect do |store_name|
      STORES[store_name].new(
        store_configs.respond_to?(store_name) ? store_configs.send(store_name) : {}
      )
    end
  end

end
