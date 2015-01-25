#
#
#
class OnesnooperServer::Datagram

  #
  #
  #
  def initialize(params = {})
    @params = params
  end

  #
  #
  #
  def run(deferred_callback)
    fail "This method needs to be implemented in subclasses"
  end

private

  #
  #
  #
  def process(deferred_callback, message)
    ::EventMachine.defer { deferred_callback.succeed(message) }
  end

end
