# Base class for all datagram processing classes. Defines
# required stub methods. No functionality is implemented here.
class OnesnooperServer::Datagram

  # Initializes class instances.
  #
  # @param params [Hash] hash-like with params
  def initialize(params = {})
    @params = params
  end

  # Runs datagram processing for the chosen datagram type.
  #
  # @param deferred_callback [::EventMachine::DefaultDeferrable] response callback
  def run(deferred_callback)
    fail "This method needs to be implemented in subclasses"
  end

end
