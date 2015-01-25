# Base class for all backend data stores. Implements key
# method stubs required for all specific backend data store
# implementations.
class OnesnooperServer::Store
  # Initializes data store instance with given parameters.
  #
  # @param params [Hash] hash-like structure with parameters
  def initialize(params = {})
    @params = params
  end

  # Saves given data set into the underlying data store.
  # Behavior is determined by the underlying data store
  # implementation.
  #
  # @param data [Hash] data to be saved in the data store
  def save(data)
    fail "This method needs to be implemented in subclasses"
  end
end
