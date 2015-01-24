#
#
#
class OnesnooperServer::Datagram
  #
  #
  #
  def initialize(param = "")
    @param = param
  end

  #
  #
  #
  def run(defer)
    fail "This method needs to be implemented in subclasses"
  end

private
  #
  #
  #
  def process(defer, time, message)
    ::EM.defer do
      sleep(time)
      defer.succeed(message)
    end
  end
end
